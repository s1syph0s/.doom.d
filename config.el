;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Pasha Fistanto"
      user-mail-address "pasha@fstn.top")

(when (string-equal (system-name) "johndoe")
  (setq user-mail-address "fistanto@ibr.cs.tu-bs.de"))

(setq +notmuch-sync-backend 'mbsync)
(after! notmuch
  (set-popup-rule! "^\*notmuch-hello" :ignore t))

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "SauceCodePro NFM" :size 16)
      doom-symbol-font (font-spec :family "DejaVu Sans Mono")
      doom-emoji-fallback-font-families nil
      doom-symbol-fallback-font-families nil)

;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-oceanic-next)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setenv "GPG_AGENT_INFO" nil)
(setq auto-save-default nil)

;; Shell
(setq! shell-file-name "fish")

;; Which Key
(after! which-key
  (setq! which-key-idle-delay 0.2)
  (setq! which-key-prefix-prefix "+"))

(setq! fill-column 80
       message-fill-column 80)
;; Org
(after! org
  (add-hook 'org-mode-hook #'auto-fill-mode)

  ;; Org crypt
  (setq! org-crypt-key user-mail-address)

  ;; Org Modern
  (setq! org-modern-star 'replace)
  (setq! org-modern-replace-stars "◉○")

  ;; Org appear
  (setq! org-appear-autolinks t)

  ;; Org Agenda
  (setq! org-log-done t)
  (setq! org-hide-emphasis-markers t)
  (setq! org-capture-templates '(("t" "Personal todo" entry
                                  (file +org-capture-todo-file)
                                  "* TODO %?\n%i\n%a" :prepend t)
                                 ("n" "Personal notes" entry
                                  (file +org-capture-notes-file)
                                  "* %u %?\n%i\n%a" :prepend t)
                                 ("j" "Journal" entry
                                  (file+olp+datetree +org-capture-journal-file)
                                  "* %U %?\n%i\n%a" :prepend t)
                                 ("p" "Templates for projects")
                                 ("pt" "Project-local todo" entry
                                  (file+headline +org-capture-project-todo-file "Inbox")
                                  "* TODO %?\n%i\n%a" :prepend t)
                                 ("pn" "Project-local notes" entry
                                  (file+headline +org-capture-project-notes-file "Inbox")
                                  "* %U %?\n%i\n%a" :prepend t)
                                 ("pc" "Project-local changelog" entry
                                  (file+headline +org-capture-project-changelog-file "Unreleased")
                                  "* %U %?\n%i\n%a" :prepend t)
                                 ("o" "Centralized templates for projects")
                                 ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
                                 ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
                                 ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t)))

  ;; Org Roam
  (setq! org-roam-capture-templates
         '(("d" "default" plain
            "%?"
            :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n") :unnarrowed t)
           ("b" "book notes" plain
            "* Source\n\nAuthor: %^{Author}\nTitle: ${title}\nYear: %^{Year}\n\n* Summary\n\n%?"
            :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
            :unnarrowed t))
         )
  (setq! citar-bibliography '("~/org/roam/references.bib")))

(after! org-download
  (setq! org-download-screenshot-method "grim -g $(slurp -d) %s"))

;; Rust
(after! rustic
  (setq! rustic-indent-where-clause t)
  ;; Patch rustfmt config
  (set-formatter! 'rustfmt '("rustfmt" "--edition" "2024" "--quiet" "--emit" "stdout")))

;; To enable features, enable in .dir-locals.el: lsp-rust-features [ "all" ]

;; Nix
(after! nix-mode
  (set-formatter! 'alejandra '("alejandra" "--quiet") :modes '(nix-mode)))

(defun my/consult-lsp-file-symbols ()
  "Consult LSP File Symbols with Category"
  (interactive)
  (consult-lsp-file-symbols t))

(setq! projectile-project-search-path "~/src")

(use-package! lsp-mode)
(after! lsp-mode
  (setq! lsp-headerline-breadcrumb-enable t
         lsp-enable-snippet nil
         lsp-signature-doc-lines 8)
  (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))
  (lsp-register-client (make-lsp-client
                        :new-connection (lsp-stdio-connection "tinymist")
                        :activation-fn  (lsp-activate-on "typst")
                        :server-id 'tinymist))

  (add-hook 'typst-ts-mode-local-vars-hook #'lsp! 'append)
  (map! :leader
        (:prefix ("c" . "code")
         "j" nil
         "J" nil
         :desc "Jump to symbol in current file" "j" #'my/consult-lsp-file-symbols
         :desc "Jump to symbol in current workspace" "J" #'consult-lsp-symbols)))

;; Hledger
(setq! ledger-binary-path "hledger.sh"
       ledger-default-date-format "%Y-%m-%d"
       ledger-mode-should-check-version nil
       ledger-report-auto-width nil
       ledger-report-links-in-register nil
       ledger-report-native-highlighting-arguments '("--color=always")
       ledger-reports '(("bal" "%(binary) -f %(ledger-file) bal -t")
                        ("reg" "%(binary) -f %(ledger-file) reg")
                        ("payee" "%(binary) -f %(ledger-file) reg payee:%(payee)")
                        ("account" "%(binary) -f %(ledger-file) reg %(account)")))
(add-to-list 'auto-mode-alist '("\\.journal\\'" . ledger-mode))

;; Just mode
(add-hook 'just-mode-hook (lambda () (dtrt-indent-mode 0)))

;; Keymaps
(define-key input-decode-map "\C-i" [C-i])


(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)
