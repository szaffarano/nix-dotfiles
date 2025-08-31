;;; init.el --- Bootstrap literate configuration -*- lexical-binding: t -*-

;; ===================================================
;; DO NOT MODIFY THIS FILE
;; Make all configuration changes in config.org
;; ===================================================

;; This file bootstraps the literate configuration from config.org
;; This file should NEVER be modified or overwritten
;; All configuration changes should be made in config.org

;; Temporarily increase GC threshold during startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Reset after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000)
                  gc-cons-percentage 0.1)))

;; Bootstrap org if needed and load literate config
(let ((config-org (expand-file-name "config.org" user-emacs-directory))
      (config-el (expand-file-name "config.el" user-emacs-directory)))
  (cond
   ((not (file-exists-p config-org))
    (error "Configuration file %s not found!" config-org))
   ((or (not (file-exists-p config-el))
        (file-newer-than-file-p config-org config-el))
    (require 'org)
    (org-babel-load-file config-org))
   (t
    (load-file config-el))))
