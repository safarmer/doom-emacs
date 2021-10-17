;;; lang/flutter/config.el -*- lexical-binding: t; -*-

;; Assuming usage with dart-mode
(use-package! dart-mode
;;  :ensure-system-package (dart_language_server . "pub global activate dart_language_server")
  :hook (dart-mode . (lambda ()
                      (add-hook 'after-save-hook #'flutter-run-or-hot-reload nil t)))
  :custom
  (dart-format-on-save t))

(use-package! flutter
  :after dart-mode
  :bind (:map dart-mode-map
              ("C-M-x" . #'flutter-run-or-hot-reload))
  :custom
  (flutter-sdk-path "/home/shane/.local/opt/flutter")

  :init
  (defun flutter-run-or-hot-restart ()
    "Start `flutter run` or hot-restart if already running."
    (interactive)
    (if (flutter--running-p)
        (flutter-hot-restart)
      (flutter-run)))
  (map! :leader
      (:prefix-map ("c" . "code")
       :desc "Hot Reload Flutter"               "r"     #'flutter-run-or-hot-reload
       :desc "Hot Restart Flutter"              "R"     #'flutter-run-or-hot-restart))
  (add-hook! dart-mode 'lsp))


(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024 100)
      company-minimum-prefix-length 0
      ;company-idle-delay 0
      ;company-tooltip-align-annotations t
      lsp-lens-enable t
      lsp-signature-auto-activate nil)
