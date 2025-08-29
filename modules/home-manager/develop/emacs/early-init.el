;; Defer garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Reset gc-cons-threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000)
                  gc-cons-percentage 0.1)))

;; Prevent unwanted runtime compilation for native-comp
(setq native-comp-deferred-compilation nil
      native-comp-async-report-warnings-errors nil)

;; Disable package.el in favor of elpaca
(setq package-enable-at-startup nil)

;; Remove some visual elements early
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Prevent the glimpse of un-styled Emacs by disabling these UI elements early
(setq tool-bar-mode nil
      menu-bar-mode nil
      scroll-bar-mode nil)

;; Resizing the Emacs frame can be a terribly expensive part of changing the font
(setq frame-inhibit-implied-resize t)

;; Disable startup screen
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t
      initial-scratch-message nil)

;; Ignore X resources
(advice-add #'x-apply-session-resources :override #'ignore)

;; Faster reading from processes
(setq read-process-output-max (* 1024 1024)) ; 1mb

(provide 'early-init)
