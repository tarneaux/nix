(setq comp-deferred-compilation nil)

(package-initialize)

;; Define XDG directories
(setq-default user-emacs-config-directory
 (concat (getenv "HOME") "/.config/emacs"))
(setq-default user-emacs-data-directory
 (concat (getenv "HOME") "/.local/share/emacs"))
(setq-default user-emacs-cache-directory
 (concat (getenv "HOME") "/.cache/emacs"))

;; Display emojis
(setf use-default-font-for-symbols nil)
(set-fontset-font t 'symbol "Noto Color Emoji" nil 'append)

;; Disable creation of lock-files named .#<filename>.
(setq-default create-lockfiles nil)

;; Set font
(set-face-attribute 'default nil :font "FantasqueSansM Nerd Font-9")

;; Disable some UI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Enable relative line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; Unless the $XGD_DATA_DIR/emacs/backup directory exists, create it. Then set as backup directory.
(let ((backup-dir (concat user-emacs-data-directory "/backup")))
  (unless (file-directory-p backup-dir)
    (mkdir backup-dir t))
  (setq-default backup-directory-alist (cons (cons "." backup-dir) nil)))

;; Unless the $XGD_DATA_DIR/emacs/undo directory exists, create it. Then set as undo directory.
(let ((backup-dir (concat user-emacs-data-directory "/undo")))
  (unless (file-directory-p backup-dir)
    (mkdir backup-dir t))
  (setq-default undo-tree-history-directory-alist (cons (cons "." backup-dir) nil)))


;; Gruvbox
(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-dark-medium t)
  ;; I don't like the default line number colors
  ; (set-face-attribute 'line-number nil :background "#0000" :foreground "#504945")
  ; (set-face-attribute 'line-number-current-line nil :background "#0000")
  ;; Disable highlighting of new lines
  ;;(set-face-attribute 'fringe nil :background "#0000")
)


;; Evil mode
(use-package evil
 :config
 (evil-mode 1))

;; Org mode
(use-package org
 :config
 (setq org-starttup-indented t
   org-hide-leading-stars t
   ; org-ellipsis ""
   org-src-fontify-natively t
   org-src-tab-acts-natively t
   org-src-preserve-indentation t
   org-src-window-setup 'current-window
   org-log-done 'time
   org-todo-keywords '((sequence "TODO" "LATER" "DONE"))
   org-startup-folded t
   org-hide-emphasis-markers t))

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(custom-theme-set-faces
  'user
  `(org-document-title ((t (:height 2.0 :underline nil))))
  `(org-level-1 ((t (:height 1.75))))
  `(org-level-2 ((t (:height 1.5))))
  `(org-level-3 ((t (:height 1.25))))
  `(org-level-4 ((t (:height 1.1)))))

