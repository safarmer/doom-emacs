;;; shane/bindings/config.el -*- lexical-binding: t; -*-

(map!
 :mode #'flutter
   "C-\\"         #'lsp-dart-dap-flutter-hot-reload
   "C-|"          #'lsp-dart-dap-flutter-hot-restart
)

(map!
 :desc "start auto-complete"    "C-."   #'company-complete

 :leader
 (:prefix-map ("y" . "yarn")
  :desc "Yarn install"          "i"     #'yarn-install
  :desc "Yarn add package"      "a"     #'yarn-add
  :desc "Yarn test"             "t"     #'yarn-test))
