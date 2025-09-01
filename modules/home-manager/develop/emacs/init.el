;;; init.el --- Bootstrap literate configuration -*- lexical-binding: t -*-

;; Set alternative locations for no-littering
(defvar no-littering-etc-directory (expand-file-name "~/.cache/emacs/etc"))
(defvar no-littering-var-directory (expand-file-name "~/.cache/emacs/var"))

(defvar use-package-compute-statistics t)

(when (boundp 'native-comp-eln-load-path)
  (startup-redirect-eln-cache (expand-file-name "eln-cache" no-littering-var-directory)))

;; elpaca bootstrap
(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" no-littering-var-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                 ,@(when-let ((depth (plist-get order :depth)))
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
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(elpaca org)

;; Use no-littering to automatically set common paths to the new user-emacs-directory
(use-package no-littering
  :ensure t
  :init
  (setq no-littering-etc-directory (expand-file-name "~/.cache/emacs/etc")
        no-littering-var-directory (expand-file-name "~/.cache/emacs/var"))
  :config
  (no-littering-theme-backups)
  (setq url-history-file (no-littering-expand-etc-file-name "url/history")
        custom-file (no-littering-expand-etc-file-name "custom.el")))

;; delight aux package needed for configuration loading
(use-package delight
  :ensure t)

;; Wait to every queued elpaca order to finish
(elpaca-wait)

(let ((config-el (expand-file-name "config.el" user-emacs-directory))
      (config-org (expand-file-name "config.org" user-emacs-directory)))
  (if (and (file-exists-p config-el)
           (file-exists-p config-org)
           (time-less-p (file-attribute-modification-time (file-attributes config-org))
                        (file-attribute-modification-time (file-attributes config-el))))
      (load-file config-el)
    (if (file-exists-p config-org)
        (org-babel-load-file config-org)
      (error "No file `%s' found!! No configuration loaded!!" config-org))))
;;
(provide 'init)

;;; init.el ends here
