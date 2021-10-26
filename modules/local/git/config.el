;;; $DOOMDIR/modules/local/git/config.el -*- lexical-binding: t; -*-

;; (defcustom git/commit-style-checks
;;   '(summary-has-type
;;     summary-has-description
;;     summary-has-scope
;;     summary-has-body)
;;   :options '(summary-has-type
;;     summary-has-description
;;     summary-has-scope
;;     summary-has-body)
;;   :type '(list :convert-widget custom-hook-convert-widget))

;; (use-package! magit
;;   :custom
;;   (git-commit-summary-max-length 80)
;;   (git-commit-fill-column 100))

(defun configure-commit-mode ()
  (remove-hook! 'server-switch-hook 'magit-commit-diff)
  (setq git-commit-summary-max-length 80)
  (setq fill-column 100)
  (setq git-commit-fill-column 100)
  (display-fill-column-indicator-mode))

(add-hook! git-commit-mode 'configure-commit-mode)
