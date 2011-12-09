;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Load path
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(let ((default-directory "~/.emacs.d/"))
      (normal-top-level-add-to-load-path '("."))
      (normal-top-level-add-subdirs-to-load-path))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; USE THE POWERFUL VIM KEYBINDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'vimpulse)
(setq vimpulse-want-C-i-like-Vim nil)
(setq vimpulse-want-C-u-like-Vim nil)
(setq vimpulse-want-change-state nil)
(setq vimpulse-want-change-undo nil)
(setq vimpulse-want-vi-keys-in-dired t)
(setq vimpulse-want-quit-like-Vim t)

(setq viper-auto-indent t)
(setq viper-case-fold-search t)
(setq viper-want-emacs-keys-in-insert t)

; S-expressions
(vimpulse-define-text-object vimpulse-sexp (arg)
  "Select a S-expression."
  :keys '("ae" "ie")
  (vimpulse-inner-object-range
   arg
   'backward-sexp
   'forward-sexp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Auto complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/home/ivan/.emacs.d/ac-dict")
(ac-config-default)
(setq ac-auto-start t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Misc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Scroll 1 line per step
(setq scroll-step 1)

; Line and column numbering
(line-number-mode 1)
(column-number-mode 1)
(global-linum-mode 1)
(setq linum-format "%3d ")

; Set size used when formatting paragraphs
(setq-default fill-column 72)

; Turn syntax-highlight on
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

; Interface
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(menu-bar-mode -1)
(setq inhibit-startup-screen 1)
(setq initial-scratch-message nil)
; don't add newlines when cursor goes past the end of file
(setq next-line-add-newlines nil)

; Font
(set-face-attribute 'default nil :family "Droid Sans Mono Slashed" :height 120)

; Colors
(require 'color-theme)
(color-theme-initialize)
(setq color-theme-is-global t)
;(color-theme-wombat)
(color-theme-solarized-dark)

; Whitespace
(setq-default show-trailing-whitespace t)
(setq-default indicate-empty-lines t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Slime
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "/usr/share/common-lisp/source/slime/")
(setq inferior-lisp-program "/usr/bin/sbcl")
(require 'slime-autoloads)
(slime-setup '(slime-fancy))

(add-hook 'slime-mode-hook
          (lambda ()
            (unless (slime-connected-p)
              (save-excursion (slime)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Backup file configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq make-backup-files t)
(setq version-control nil)
(setq backup-directory-alist (quote ((".*" . "~/.emacs.d/backup"))))
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File type settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq standard-indent 4) ; Setting indent size to 4
(setq-default indent-tabs-mode nil) ; Tabs expand to spaces

; Lisp
(add-hook 'lisp-mode-hook
          '(lambda ()
            (set (make-local-variable 'lisp-indent-function)
                 'common-lisp-indent-function)))

(add-hook 'lisp-mode-hook
          '(lambda ()
             (local-set-key (kbd "RET") 'newline-and-indent)))

(font-lock-add-keywords 'emacs-lisp-mode
                        '(("\\<\\(add-hook\\)" 1 font-lock-builtin-face t)
                          ("\\<\\(set-hook\\)" 1 font-lock-builtin-face t)
                          ("\\<\\(add-to-list\\)" 1 font-lock-builtin-face t)))
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (local-set-key (kbd "RET") 'newline-and-indent)))

; C
(add-hook 'c-mode-common-hook
          '(lambda () (c-toggle-auto-state 1)))

(add-hook 'c-mode-common-hook
          '(lambda ()
             (local-set-key (kbd "RET") 'newline-and-indent)))

(setq c-default-style "k&r"
      c-basic-offset 4)

; Haskell
(load "~/.emacs.d/haskellmode-emacs/haskell-site-file.el")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(setq haskell-font-lock-symbols t)
(add-hook 'haskell-mode-hook 'turn-on-font-lock)
(add-hook 'haskell-mode-hook
          '(lambda ()
             (local-set-key (kbd "RET") 'newline-and-indent)))
