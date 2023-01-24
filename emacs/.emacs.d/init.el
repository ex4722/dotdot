(setq inhibit-startup-message t)

(tool-bar-mode -1)
(menu-bar-mode -1) 
(toggle-scroll-bar -1) 

(defalias 'yes-or-no-p 'y-or-n-p)

;; Options
(column-number-mode)
(global-display-line-numbers-mode t)
(scroll-bar-mode 0)

(dolist (mode '(org-mode-hook term-mode-hook eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


(setq custom-file "~/.config/emacs/custom-vars.el")
(load custom-file 'noerror 'nomessage)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))


(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t
      )

(remove-hook 'tty-setup-hook 'doom-init-clipboard-in-tty-emacs-h)
(setq select-enable-clipboard nil)



(use-package evil
  ; SET BEFORE EVIl RUNS
  :init 
  (setq evil-want-C-u-scroll t)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-i-jump t)
  (setq evil-want-C-u-delete t)
; Runs after package loads
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  :bind (
	 ("C-p" . (lambda () (interactive) (evil-paste-from-register ?+)))
	 :map evil-normal-state-map
	 ("C-p" . (lambda () (interactive) (evil-paste-from-register ?+)))
	 ("Y" . evil-yank-fake)
	 :map evil-insert-state-map
	 ("C-p" . (lambda () (interactive) (evil-paste-from-register ?+)))
	 :map evil-visual-state-map
	 ("C-p" . (lambda () (interactive) (evil-paste-from-register ?+)))
	 ("Y" . copy-to-clipboard-visual)
	 )
  )
(setq-default evil-escape-key-sequence "jk")

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))


(use-package evil-goggles
  :ensure t
  :config
  (evil-goggles-mode)

  (evil-goggles-use-diff-faces))

(defun copy-to-clipboard-visual()
  (interactive)
  (setq select-enable-clipboard t)
  (kill-ring-save (region-beginning) (region-end))
  (setq select-enable-clipboard nil))

(evil-define-operator evil-yank-fake (beg end type register yank-handler)
  "Save the characters in motion into the kill-ring."
  :move-point nil
  :repeat nil
  (interactive "<R><x><y>")
  (message "changed clipboard")
  (setq select-enable-clipboard t)
  (let ((evil-was-yanked-without-register
	 (and evil-was-yanked-without-register (not register))))
    (cond
     ((and (fboundp 'cua--global-mark-active)
	   (fboundp 'cua-copy-region-to-global-mark)
	   (cua--global-mark-active))
      (cua-copy-region-to-global-mark beg end))
     ((eq type 'block)
      (evil-yank-rectangle beg end register yank-handler))
     ((memq type '(line screen-line))
      (evil-yank-lines beg end register yank-handler))
     ((evil-yank-characters beg end register yank-handler)
      (goto-char beg))))
  (message "changing back")
  (setq select-enable-clipboard nil))


(use-package general
  :config
    (general-create-definer ex/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-evil-setup)) 

(general-imap "j"
  (general-key-dispatch 'self-insert-command
    :timeout 0.1
    "k" 'evil-normal-state))


(use-package ivy
  :diminish
  :bind (
	 ("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 )
  :config
  (ivy-mode 1)
  )

(use-package counsel
  :bind (
	 ("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
	 ("C-x b" . counsel-switch-buffer)
	 )
  :custom
  (ivy-initial-inputs-alist nil)
  )

(use-package ivy-rich
  :config
  (ivy-rich-mode 1)
  )




(use-package all-the-icons
  :ensure t
  )

(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 30)
  (doom-modeline-icon t)
  )
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-solarized-dark t)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  )

(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono" :height 158) 



(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :custom
  (which-key-idle-delay 0.3)
  )


(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map))
  :custom
  (projectile-project-search-path '("~/coding/" "~/ctf/" ))
  )

(use-package counsel-projectile
  :config
  (counsel-projectile-mode 1)
	   )
(use-package magit
  )


(defun reload ()
  (interactive)
  (message "reloading crap")
  (load-file "/home/ex/.emacs.d/init.el")
  )

(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono" :height 158) 


(ex/leader-keys
  "p" '(:keymap projectile-command-map :wk "projectile prefix")
  "g" '(magit-status :which-key "Magit")
  )
