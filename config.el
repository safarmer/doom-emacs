;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Shane Farmer"
      user-mail-address "shane.farmer@gmail.com")

(setq doom-scratch-initial-major-mode 'lisp-interaction-mode)


;; Disable invasive lsp-mode features
;; (setq lsp-ui-sideline-enable nil   ; not anymore useful than flycheck
;;       lsp-ui-doc-enable nil        ; slow and redundant with K
;;       lsp-enable-symbol-highlighting nil
;;       ;; If an LSP server isn't present when I start a prog-mode buffer, you
;;       ;; don't need to tell me. I know. On some systems I don't care to have a
;;       ;; whole development environment for some ecosystems.
;;       ;;+lsp-prompt-to-install-server 'quiet
;;       )

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;; (setq doom-font (font-spec :family "JetBrains Mono" :size 12))

;; "monospace" means use the system default. However, the default is usually two
;; points larger than I'd like, so I specify size 12 here.
(setq
 doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 13 :weight 'light)
 doom-variable-pitch-font (font-spec :family "Noto Sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

(setq-default
 cursor-type 'bar
 blink-cursor-mode t)


;;; :ui doom-dashboard
;; Hide the menu for as minimalistic a startup screen as possible.
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(with-eval-after-load "projectile"
  (add-to-list 'projectile-project-root-files-bottom-up "pubspec.yaml")
  (add-to-list 'projectile-project-root-files-bottom-up "package.lock")
  (add-to-list 'projectile-project-root-files-bottom-up "yarn.lock")
  (add-to-list 'projectile-project-root-files-bottom-up "gradle.properties"))

;;(setq lsp-auto-guess-root t)

;; (global-set-key (kbd "M-'") 'company-complete)
;; (global-set-key (kbd "M-]") 'projectile-next-project-buffer)
;; (global-set-key (kbd "M-[") 'projectile-previous-project-buffer)
;; (global-set-key (kbd "C-<left>") 'backward-word)
;; (global-set-key (kbd "C-<right>") 'forward-word)

(map!
 "C-." #'company-complete
 "M-<return>" #'lsp-ui-sideline-apply-code-actions)

;; formats the buffer before saving
;;(add-hook 'before-save-hook 'tide-format-before-save)
;;(add-hook 'typescript-mode-hook #'setup-tide-mode)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      company-minimum-prefix-length 1
      company-idle-delay 0.1
      company-prefix "."
      company-tooltip-align-annotations t
      lsp-lens-enable t
      lsp-dart-line-length 100
      lsp-signature-auto-activate nil)

(with-eval-after-load #'lsp-mode
  (setq
   lsp-headerline-breadcrumb-enable t
   lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols)
   lsp-modeline-code-actions-enable t
   lsp-modeline-diagnostics-enable t
   lsp-modeline-workspace-status-enable t
   lsp-modeline-diagnostics-scope :workspace))

(defun sf/multi-cursor-and-move (dir)
  "Enter multiple cursor mode if not already active and move in the direction (DIR)."
  (interactive)
  (if (eq rectangular-region-mode nil)
    (set-rectangular-region-anchor))
  (let ((arg
         (cond
          ((string= dir "up") -1)
          ((string= dir "down") 1)
          (t 0))))
    (line-move arg nil nil t)))

(defun sf/multi-cursor-up ()
  "Enter multi-cursor mode and select line above."
  (interactive)
  (sf/multi-cursor-and-move "up"))

(defun sf/multi-cursor-down ()
  "Enter multi-cursor mode and select line bellow."
  (interactive)
  (sf/multi-cursor-and-move "down"))

(map!
 :desc "mark next like this"    "C->"           #'mc/mark-next-like-this
 :desc "mark prev like this"    "C-<"           #'mc/mark-previous-like-this
 :desc "mark previous line"     "s-<up>"        #'sf/multi-cursor-up
 :desc "mark next line"         "s-<down>"      #'sf/multi-cursor-down
 :desc "last edit"              "s-["   #'previous-buffer
 :desc "last edit"              "s-]"   #'next-buffer
 :desc "next tab"               "s-}"   #'centaur-tabs-forward
 :desc "previous tab"           "s-{"   #'centaur-tabs-backward)

;; (use-package! yarn-mode)

;; (map! :leader
;;  (:prefix-map ("y" . "yarn")
;;   :desc "Yarn install"          "i"     #'yarn-install
;;   :desc "Yarn add package"      "a"     #'yarn-add
;;   :desc "Yarn test"             "t"     #'yarn-test))

(provide 'config)
;;; config.el ends here
