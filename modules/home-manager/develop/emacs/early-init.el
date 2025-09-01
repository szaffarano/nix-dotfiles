;;; early-init.el --- Early initialization file -*- lexical-binding: t -*-

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
      native-comp-async-report-warnings-errors 'silent)

;; Disable package.el in favor of elpaca
(setq package-enable-at-startup nil)

;; Remove some visual elements early
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Disable startup screen
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t
      initial-scratch-message nil)

;; Ignore X resources
(setq inhibit-x-resources t)

(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))

(provide 'early-init)
;;; early-init.el ends here
