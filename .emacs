;;; ELPA repositories and default path

(add-to-list 'load-path "/usr/share/emacs/site-lisp")

(require 'package)
(add-to-list 'package-archives
             '("marmalade" .
               "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("gnu" .
               "http://elpa.gnu.org/packages/"))

(package-initialize)
; To refresh the package list, use M-x package-refresh-contents
; List of installed packages:
;  - evil
;  - evil-leader
;  - evil-paredit
;  - flymake
;  - geiser
;  - paredit
;  - cider
(setq installed-packages-list
      '(paredit
        geiser
        evil
        evil-leader
        evil-paredit
        flymake
        cider))

; Given a list of packages, install them if they are not available
(defun check-installed-packages (packages-list)
  (when (not (null packages-list))
    (unless (package-installed-p (car packages-list))
      (package-install (car packages-list)))
    (check-installed-packages (cdr packages-list))))

(check-installed-packages installed-packages-list)

;;; USE THE POWERFUL VIM KEYBINDS

(require 'evil)
(require 'evil-paredit)
(evil-mode 1)
(setq evil-auto-indent t)
(setq evil-shift-width 4)
(setq evil-regexp-search t)
(setq evil-want-C-i-jump t)
(setq evil-want-C-u-scroll t)

;;; Flymake

(require 'flymake)
(setq ispell-program-name "hunspell")
(setq ispell-dictionary "brasileiro")

;;; Geiser
(setq geiser-repl-history-filename "~/.emacs.d/geiser-history")
(setq geiser-repl-query-on-kill-p nil)
(setq geiser-repl-query-on-exit-p t)

;;; Misc

(setq vc-handled-backends nil)

; Change yes/no para y/n
(defalias 'yes-or-no-p 'y-or-n-p)

; Scroll 1 line per step
(setq scroll-step 1)

; Line and column numbering
(line-number-mode 1)
(column-number-mode 1)
(global-linum-mode 1)
(setq linum-format "%3d ")

; Set size used when formatting paragraphs
(setq-default fill-column 80)

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

; Colors
(load-theme 'solarized-dark t)

; Font
(set-face-attribute 'default nil :family "Droid Sans Mono" :height 120)
(set-face-bold-p 'bold nil)

; Whitespace
(setq-default show-trailing-whitespace t)
(setq-default indicate-empty-lines t)

; Line wrapping (truncate)
(setq default-truncate-lines t)

;;; Slime

(add-to-list 'load-path "/usr/share/common-lisp/source/slime/")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/slime")
(setq inferior-lisp-program "/usr/bin/sbcl")
(require 'slime)
(slime-setup '(slime-fancy))

(add-hook 'slime-mode-hook
          (lambda ()
            (unless (slime-connected-p)
              (save-excursion (slime)))))

(global-set-key "\C-z" 'slime-selector)

;;; Backup file configuration

(setq make-backup-files t)
(setq version-control nil)
(setq backup-directory-alist (quote ((".*" . "~/.emacs.d/backup"))))
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2)

;;; File type settings

(which-function-mode)
(global-set-key (kbd "RET") 'newline-and-indent)
(setq standard-indent 4)
(setq-default indent-tabs-mode nil)

; Clojure
(require 'cider)
(setq nrepl-hide-special-buffers t)
(setq nrepl-repl-pop-to-buffer-on-connect nil)
(add-hook 'cider-repl-mode-hook 'paredit-mode)

; Paredit for lisp-like languages
(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
(add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode +1)))
(add-hook 'scheme-mode-hook           (lambda () (paredit-mode +1)))
(add-hook 'slime-repl-mode-hook       (lambda () (paredit-mode +1)))
(add-hook 'clojure-mode-hook          (lambda () (paredit-mode +1)
                                        'cider-mode))
;; Stop SLIME's REPL from grabbing DEL,
;; which is annoying when backspacing over a '('
(defun override-slime-repl-bindings-with-paredit ()
  (define-key slime-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil))
(add-hook 'slime-repl-mode-hook 'override-slime-repl-bindings-with-paredit)

; Lisp
(add-hook 'lisp-mode-hook
          '(lambda ()
            (set (make-local-variable 'lisp-indent-function)
                 'common-lisp-indent-function)))

(font-lock-add-keywords 'emacs-lisp-mode
                        '(("\\<\\(add-hook\\)" 1 font-lock-builtin-face t)
                          ("\\<\\(set-hook\\)" 1 font-lock-builtin-face t)
                          ("\\<\\(add-to-list\\)" 1 font-lock-builtin-face t)))

; C
(add-hook 'c-mode-common-hook
          '(lambda () (c-toggle-auto-state 1)))

(setq c-default-style "linux"
      c-basic-offset 4)
(setq c-hanging-braces-alist '((class-open after)
                               (substatement-open after)
                               (topmost-intro after)))

; Lua
(setq auto-mode-alist (cons '("\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)

; Python
(autoload 'python-mode "python-mode.el" "Python mode." t)
(setq auto-mode-alist (append '(("/*.\.py$" . python-mode)) auto-mode-alist))

; Latex
(require 'reftex)
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-save-query nil)
(setq TeX-PDF-mode t)
(setq reftex-plug-into-AUCTeX t)
(setq reftex-extra-bindings t)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-buffer)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)

; newLISP
(add-to-list 'load-path (expand-file-name "/usr/share/emacs/site-list/newlisp-mode"))
(add-to-list 'auto-mode-alist '("\\.lsp\\'" . newlisp-mode))
(autoload 'newlisp-mode "newlisp" "Turn on NewLisp mode" t)
