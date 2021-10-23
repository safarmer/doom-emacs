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
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 13 :weight 'light)
      doom-variable-pitch-font (font-spec :family "Noto Sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;(setq doom-theme 'doom-sourcerer)
(setq doom-theme 'doom-dark+)
;; (load-theme doom-theme)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

(setq-default cursor-type 'bar)

;;; :ui doom-dashboard
;; Hide the menu for as minimalistic a startup screen as possible.
;; (remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)

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
  (add-to-list 'projectile-project-root-files-bottom-up "gradle.properties"))

(setq lsp-auto-guess-root t)

;; (global-set-key (kbd "M-'") 'company-complete)
;; (global-set-key (kbd "M-]") 'projectile-next-project-buffer)
;; (global-set-key (kbd "M-[") 'projectile-previous-project-buffer)
;; (global-set-key (kbd "C-<left>") 'backward-word)
;; (global-set-key (kbd "C-<right>") 'forward-word)

;;; TypeScript Configuration

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

(map! "M-;" #'company-complete)

;; formats the buffer before saving
;;(add-hook 'before-save-hook 'tide-format-before-save)
;;(add-hook 'typescript-mode-hook #'setup-tide-mode)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024 100)
      company-minimum-prefix-length 0
      company-idle-delay 0
      company-tooltip-align-annotations t
      lsp-lens-enable t
      lsp-dart-line-length 100
      lsp-signature-auto-activate nil)

(map! :leader
 (:prefix-map ("y" . "yarn")
  :desc "Yarn install"          "i"     #'yarn-install
  :desc "Yarn add package"      "a"     #'yarn-add
  :desc "Yarn test"             "t"     #'yarn-test
  )
 )

(map!
 "C-\\"         #'lsp-dart-dap-flutter-hot-reload
 "C-|"          #'lsp-dart-dap-flutter-hot-restart
)

(add-hook! 'dart-mode-hook
  (dap-register-debug-template
   "Flutter :: Debug :: Development"
   (list :name #("Flutter :: Debug :: Development" 0 16 (face nil))
         :type "flutter"
         :target "lib/navigator_app.dart"
         :args '("--flavor" "development" "--dart-define" "THATCH_ENV=development" "--dart-define" "USE_NEW_true=ROUTER")
         )))

(use-package! company-box
  :hook
  (company-mode . company-box-mode)
  :config
  (setq company-box-icons-alist 'company-box-icons-idea))

(setq which-key-idle-secondary-delay 0.05)

(after! tree-sitter
  (tree-sitter-require 'c)
  (tree-sitter-require 'cpp)
  (tree-sitter-require 'json)
  (tree-sitter-require 'java)
  (tree-sitter-require 'javascript)
  (tree-sitter-require 'typescript)
  (tree-sitter-require 'tsx)
  (tree-sitter-require 'rust)
  (tree-sitter-require 'python)
  (tree-sitter-require 'bash)
  (global-tree-sitter-mode)
  (add-hook! 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(add-hook! java-mode #'gradle-mode)
(setq
 gradle-gradlew-executable "./gradlew"
 gradle-use-gradlew t)
