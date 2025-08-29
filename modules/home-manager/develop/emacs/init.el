;; Startup performance measurement
(defun my/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'my/display-startup-time)

;; Profile startup (uncomment to use)
;; (require 'profiler)
;; (profiler-start 'cpu)
;; (add-hook 'after-init-hook #'profiler-report)

;;; Bootstrap elpaca
(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; Install use-package support
(elpaca elpaca-use-package
  (elpaca-use-package-mode))

;; Enable use-package statistics (comment out after debugging)
(setq use-package-compute-statistics t)

;; Block until current queue processed
(elpaca-wait)

;;; Basic Emacs Settings
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq ring-bell-function 'ignore)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq confirm-kill-emacs nil)
(setq scroll-conservatively 101)
(setq scroll-margin 5)
(setq use-dialog-box nil)
(setq use-short-answers t)
(setq echo-keystrokes 0.1)
(setq native-comp-async-report-warnings-errors nil)

;; UTF-8
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Terminal-specific settings
(menu-bar-mode -1)
(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

;; Line numbers and column indicator
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(setq display-line-numbers-type 'relative)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

;; Whitespace
(setq-default show-trailing-whitespace t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Parenthesis
(show-paren-mode 1)
(electric-pair-mode 1)

;; Recent files
(use-package recentf
  :config
  (setq recentf-max-menu-items 25)
  (setq recentf-max-saved-items 25)
  (setq recentf-auto-cleanup 'never)  ; Don't cleanup on startup
  (setq recentf-exclude '("/tmp/"
                          "/elpaca/"
                          "/elpa/"
                          "/straight/"
                          "recentf"
                          "COMMIT_EDITMSG"
                          ".gz$"
                          "~$"))
  (recentf-mode 1)
  ;; Clean up only when idle for 60 seconds
  (run-with-idle-timer 60 nil 'recentf-cleanup))

;; Auto revert buffers
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;;; Evil Mode
(use-package evil
  :ensure (:wait t)
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-redo)
  (setq evil-search-module 'evil-search)
  (setq evil-want-Y-yank-to-eol t)
  :config
  (evil-mode 1)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  ;; Set leader key
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-leader 'visual (kbd "SPC")))

(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

;; Better escape
(use-package evil-escape
  :ensure t
  :after evil
  :config
  (evil-escape-mode)
  (setq evil-escape-key-sequence "jk")
  (setq evil-escape-delay 0.2))

;; Surround
(use-package evil-surround
  :ensure t
  :after evil
  :config
  (global-evil-surround-mode 1))

;; Commentary
(use-package evil-commentary
  :ensure t
  :after evil
  :config
  (evil-commentary-mode))

;;; General.el for better keybinding management
(use-package general
  :ensure t
  :after evil
  :config
  (general-create-definer my-leader-def
    :states '(normal visual insert emacs)
    :keymaps 'override
    :prefix "SPC"
    :non-normal-prefix "M-SPC")

  ;; File operations
  (my-leader-def
    "f" '(:ignore t :which-key "file")
    "ff" 'find-file
    "fr" 'recentf-open-files
    "fs" 'save-buffer
    "fS" 'save-some-buffers
    "fc" 'save-buffers-kill-terminal
    "fq" 'kill-emacs

    ;; Buffer operations
    "b" '(:ignore t :which-key "buffer")
    "bb" 'switch-to-buffer
    "bd" 'kill-current-buffer
    "bk" 'kill-buffer
    "bn" 'next-buffer
    "bp" 'previous-buffer
    "br" 'revert-buffer

    ;; Window operations
    "w" '(:ignore t :which-key "window")
    "ww" 'other-window
    "wd" 'delete-window
    "ws" 'split-window-below
    "wv" 'split-window-right
    "wh" 'windmove-left
    "wj" 'windmove-down
    "wk" 'windmove-up
    "wl" 'windmove-right
    "w=" 'balance-windows

    ;; Quick actions
    "SPC" 'execute-extended-command
    "/" 'comment-line
    "u" 'undo-tree-undo
    "r" 'undo-tree-redo
    "h" '(:ignore t :which-key "help")
    "hf" 'describe-function
    "hv" 'describe-variable
    "hk" 'describe-key

    ;; Quit operations
    "q" '(:ignore t :which-key "quit")
    "qq" 'save-buffers-kill-terminal
    "qQ" 'kill-emacs))

;;; Undo Tree (better undo for Evil)
(use-package undo-tree
  :ensure t
  :after evil
  :diminish
  :config
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1)
  (setq undo-tree-history-directory-alist `(("." . ,(expand-file-name "undo" user-emacs-directory))))
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-diff t))

;;; Which Key
(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3))

;;; Completion Framework
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :config
  (setq vertico-cycle t))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :ensure t
  :after general
  :bind (("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x r b" . consult-bookmark)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi))
  :config
  (my-leader-def
    "s" '(:ignore t :which-key "search")
    "ss" 'consult-line
    "sS" 'consult-line-multi
    "sg" 'consult-grep
    "sG" 'consult-git-grep
    "sr" 'consult-ripgrep
    "si" 'consult-imenu
    "so" 'consult-outline
    "sb" 'consult-buffer))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;;; Org Mode
(use-package org
  :ensure t
  :defer t  ; Load only when needed
  :after general
  :mode ("\\.org\\'" . org-mode)
  :config
  (setq org-ellipsis " ▾")
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-hide-emphasis-markers t)
  (setq org-startup-folded 'content)
  (setq org-cycle-separator-lines 2)
  (setq org-capture-bookmark nil)
  (setq org-directory "~/org/")
  (setq org-agenda-files '("~/org/"))

  ;; Org babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)))

  (setq org-confirm-babel-evaluate nil)

  ;; Org keys
  (my-leader-def
    "o" '(:ignore t :which-key "org")
    "oa" 'org-agenda
    "oc" 'org-capture
    "od" 'org-deadline
    "oe" 'org-export-dispatch
    "oi" 'org-insert-heading
    "ol" 'org-insert-link
    "on" 'org-store-link
    "os" 'org-schedule
    "ot" 'org-todo))

;; Better org bullets
(use-package org-bullets
  :ensure t
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;;; Org-roam
(use-package org-roam
  :ensure t
  :defer t  ; Don't load until needed
  :after general
  :commands (org-roam-node-find org-roam-capture org-roam-buffer-toggle)
  :custom
  (org-roam-directory "~/org/roam/")
  (org-roam-completion-everywhere t)
  :config
  (org-roam-db-autosync-mode)

  ;; Configure capture templates
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n#+date: %U\n")
           :unnarrowed t)))

  ;; Org-roam keybindings
  (my-leader-def
    "n" '(:ignore t :which-key "notes")
    "nf" 'org-roam-node-find
    "ni" 'org-roam-node-insert
    "nl" 'org-roam-buffer-toggle
    "nt" 'org-roam-tag-add
    "na" 'org-roam-alias-add
    "nc" 'org-roam-capture
    "nr" 'org-roam-ref-add
    "nd" 'org-roam-dailies-capture-today
    "nD" 'org-roam-dailies-goto-today))

;;; Git integration
;; Install transient first (magit dependency)
(use-package transient
  :ensure t)

(use-package magit
  :ensure t
  :after (general transient)
  :commands magit-status
  :config
  (my-leader-def
    "g" '(:ignore t :which-key "git")
    "gs" 'magit-status
    "gb" 'magit-blame
    "gd" 'magit-diff-dwim
    "gD" 'magit-diff
    "gc" 'magit-commit
    "gp" 'magit-push
    "gP" 'magit-pull
    "gf" 'magit-fetch
    "gl" 'magit-log-current
    "gL" 'magit-log))

;;; Theme
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-org-config))

;; Modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25)
  (setq doom-modeline-bar-width 3)
  (setq doom-modeline-buffer-file-name-style 'truncate-except-project))

;;; File tree
(use-package treemacs
  :ensure t
  :after general
  :defer t
  :config
  (setq treemacs-width 30)
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)
  (my-leader-def
    "e" 'treemacs
    "E" 'treemacs-select-window))

(use-package treemacs-evil
  :ensure t
  :after (treemacs evil))

;;; Terminal
(use-package vterm
  :ensure t
  :after general
  :commands vterm
  :config
  (setq vterm-shell (executable-find "bash"))
  (setq vterm-max-scrollback 10000)
  (my-leader-def
    "t" '(:ignore t :which-key "terminal")
    "tt" 'vterm
    "tv" 'vterm-other-window
    "tn" 'vterm))

;;; Project management
(use-package projectile
  :ensure t
  :after general
  :init
  (projectile-mode +1)
  :config
  (setq projectile-completion-system 'default)
  (my-leader-def
    "p" '(:ignore t :which-key "project")
    "pp" 'projectile-find-file
    "ps" 'projectile-switch-project
    "pg" 'projectile-grep
    "pr" 'projectile-replace
    "pc" 'projectile-compile-project
    "pt" 'projectile-test-project
    "pb" 'projectile-switch-to-buffer
    "pd" 'projectile-dired
    "pf" 'projectile-find-file
    "pF" 'projectile-find-file-in-known-projects))

;;; Better help
(use-package helpful
  :ensure t
  :bind
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key)
  ([remap describe-command] . helpful-command))

;;; Rainbow delimiters
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;;; Language Support
;; Tree-sitter for better syntax highlighting
(use-package treesit-auto
  :ensure t
  :defer 1  ; Load after 1 second
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; Language modes - all deferred until needed
;; Python
(use-package python-mode
  :ensure t
  :defer t
  :mode "\\.py\\'"
  :config
  (setq python-indent-offset 4))

;; Rust
(use-package rust-mode
  :ensure t
  :defer t
  :mode "\\.rs\\'"
  :config
  (setq rust-format-on-save t))

;; Nix
(use-package nix-mode
  :ensure t
  :defer t
  :mode "\\.nix\\'")

;; Go
(use-package go-mode
  :ensure t
  :defer t
  :mode "\\.go\\'")

;; TypeScript/JavaScript
(use-package typescript-mode
  :ensure t
  :defer t
  :mode "\\.ts\\'")

(use-package js2-mode
  :ensure t
  :defer t
  :mode "\\.js\\'"
  :config
  (setq js2-basic-offset 2))

;; JSON
(use-package json-mode
  :ensure t
  :defer t
  :mode "\\.json\\'")

;; YAML
(use-package yaml-mode
  :ensure t
  :defer t
  :mode "\\.ya?ml\\'")

;; Markdown
(use-package markdown-mode
  :ensure t
  :defer t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; Dockerfile
(use-package dockerfile-mode
  :ensure t
  :defer t
  :mode "Dockerfile\\'")

;; TOML
(use-package toml-mode
  :ensure t
  :defer t
  :mode "\\.toml\\'")

;; Web development (HTML/CSS)
(use-package web-mode
  :ensure t
  :defer t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.vue\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

;; Lua
(use-package lua-mode
  :ensure t
  :defer t
  :mode "\\.lua\\'")

;; Enhanced syntax highlighting for all languages
(use-package highlight-numbers
  :ensure t
  :defer t
  :hook (prog-mode . highlight-numbers-mode))

(use-package highlight-quoted
  :ensure t
  :defer t
  :hook (emacs-lisp-mode . highlight-quoted-mode))

(use-package hl-todo
  :ensure t
  :defer 2  ; Load after 2 seconds
  :config
  (setq hl-todo-keyword-faces
        '(("TODO"   . "#FF0000")
          ("FIXME"  . "#FF0000")
          ("DEBUG"  . "#A020F0")
          ("GOTCHA" . "#FF4500")
          ("NOTE"   . "#1E90FF")))
  (global-hl-todo-mode 1))

;;; Performance
(setq gc-cons-threshold (* 2 1000 1000))
(setq read-process-output-max (* 1024 1024))

(provide 'init)
