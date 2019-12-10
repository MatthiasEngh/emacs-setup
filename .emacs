(setq custom-tab-width 2)

;; keybiniding
(global-set-key (kbd "C-j") 'forward-word)
(global-set-key (kbd "C-b") 'backward-word)
(global-set-key (kbd "C-m") 'newline-and-indent)

;; remove whitespace (do a bunch of random unknown stuff)
;(add-hook 'before-save-hook 'whitespace-cleanup)
;(setq whitespace-style '("space-before-tab::space"))

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; to load changes applied here do <M-x> load-file

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-maximum-decoration t)
 '(package-selected-packages
   (quote
    (robe string-inflection inf-ruby yasnippet-classic-snippets yasnippet-snippets yasnippet rspec-mode yaml-mode enh-ruby-mode auto-complete projectile tide company typescript-mode js2-mode web-mode ## dash)))
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))

;; for viewing slim files
(require 'slim-mode)

;; enable winner mode
(when (fboundp 'winner-mode)
  (winner-mode t))

;; configure default magit status keybinding
(global-set-key (kbd "C-x g") 'magit-status)

;; enable syntax highlighting
(global-font-lock-mode t)

;; set syntax highlighting to max
(setq font-lock-maximum-decoration t)

;; Navigate between windows using Alt-1, Alt-2, Shift-Left, Shift-Up, Shift-Right
(windmove-default-keybindings)

;; Enable copy and pasting from clipboard
(setq x-select-enable-clipboard t)

;; enable line numbers
(global-display-line-numbers-mode)

;; auto completion
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories
    "~/.emacs.d/.cask/24.3.50.1/elpa/auto-complete-20130724.1750/dict")
(ac-config-default)
(setq ac-ignore-case nil)
(add-to-list 'ac-modes 'enh-ruby-mode)
(add-to-list 'ac-modes 'web-mode)

;; tide
(require 'flycheck)
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)
(setq tide-format-options '(:indentSize 2 :tabSize 2 :convertTabsToSpaces t))

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; enable web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-hook 'web-mode-hook
	  (lambda ()
	    (when (string-equal "tsx" (file-name-extension buffer-file-name))
	      (setup-tide-mode))))
(add-hook 'web-mode-hook
	  (lambda ()
	    (when (string-equal "ts" (file-name-extension buffer-file-name))
	      (setup-tide-mode))))

;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)
(flycheck-add-mode 'typescript-tslint 'typescript-mode)

;; quick browsing of files
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; indents
(setq js-indent-level custom-tab-width)
(setq-default js2-basic-offset custom-tab-width)
(setq typescript-indent-level custom-tab-width)
(setq web-mode-markup-indent-offset custom-tab-width)
(setq web-mode-code-indent-offset custom-tab-width)
(setq ruby-indent-level custom-tab-width)

(add-hook 'html-mode-hook
	  (lambda ()
	    (set (make-local-variable 'sgml-basic-offset) custom-tab-width)))
(put 'erase-buffer 'disabled nil)

;; rspec mode
(add-to-list 'load-path "/path/to/rspec-mode")
(require 'rspec-mode)
(eval-after-load 'rspec-mode
  '(rspec-install-snippets))
(add-hook 'after-init-hook 'inf-ruby-auto-enter)
(add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)

;; ruby completions
(add-hook 'ruby-mode-hook 'enh-ruby-mode)
(add-hook 'enh-ruby-mode-hook 'robe-mode)

;; yasnippet
(add-to-list 'load-path
	     "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode t)
