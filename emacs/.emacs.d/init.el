(setq inhibit-startup-message t)
(setq user-full-name "Eddie Xiao")

(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono" :height 158)
(tool-bar-mode -1)
(menu-bar-mode -1) 
(toggle-scroll-bar -1)
(scroll-bar-mode 0)
(defalias 'yes-or-no-p 'y-or-n-p)
(column-number-mode)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)

(setq
 
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.emacs.d/backup"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

(require 'package)
  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
			   ("org" . "https://orgmode.org/elpa/")
			   ("elpa" . "https://elpa.gnu.org/packages/")
			  ("melpa-stable" . "http://stable.melpa.org/packages/") 
))
(package-initialize)
(unless package-archive-contents
    (package-refresh-contents))
;; This is only needed once, near the top of the file
(eval-when-compile
  (package-install 'use-package)
  (require 'use-package)
  )

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package general
  :config
  (general-auto-unbind-keys nil)
  (general-create-definer ex/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-evil-setup))

(use-package evil 
  :init 
    (setq evil-want-keybinding nil)
    (setq evil-want-C-u-scroll t)
    (setq evil-want-integration t)
    (setq evil-want-keybinding nil)
    (setq evil-want-C-i-jump t)
    (setq evil-want-C-u-delete t)

  :config 
  (evil-mode 1)
  )

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
 (setq select-enable-clipboard nil))

(general-def
 :states '(normal insert visual)
 "C-p" (lambda () (interactive) (evil-paste-from-register ?+)))

;; Bind in specific maps using :keymaps
(general-def
 :keymaps 'evil-normal-state-map
 "Y" 'evil-yank-fake)

(general-def
 :keymaps 'evil-visual-state-map
 "Y" 'copy-to-clipboard-visual)

(general-def
 :keymaps 'evil-insert-state-map
 "C-p" (lambda () (interactive) (evil-paste-from-register ?+)))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(general-imap "j"
  (general-key-dispatch 'self-insert-command
    :timeout 0.25
    "k" 'evil-normal-state))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)))
(defun ex/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.emacs.d/init.org"))
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'ex/org-babel-tangle-config)))

(defun reload ()
  (interactive)
  (message "reloading crap")
  (load-file "~/.emacs.d/init.el")
  )
(global-set-key (kbd "C-S-r") 'reload)

(defun ex/edit-configuration ()
  "Open the init file."
  (interactive)
  (find-file "/home/ex/.emacs.d/init.org"))

(use-package org
  :config

(setq org-hide-emphasis-markers t)

(setq org-ellipsis " ▾")
)

(use-package org-fragtog
  :after org
  :hook (org-mode . org-fragtog-mode) ; this auto-enables it when you enter an org-buffer, remove if you do not want this
  )
  (plist-put org-format-latex-options :scale 2)
(use-package tex
:ensure auctex)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  (org-mode . visual-line-mode)
  (org-mode . flyspell-mode)
  )

(defun ex/org-mode-visual-fill ()
  (setq visual-fill-column-width 200
	  visual-fill-column-center-text t)
  (setq visual-fill-column-width 103)
  (setq display-line-number-mode nil)
  (visual-fill-column-mode 1)
  )

(use-package visual-fill-column
  :hook (org-mode . ex/org-mode-visual-fill))

(use-package all-the-icons
  )
(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 30)
  (doom-modeline-icon t)
  )

(use-package doom-themes
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

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Enable vertico
(use-package vertico
  :custom
  (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode)
  (keymap-set vertico-map "TAB" #'minibuffer-complete)
  (setq completion-styles '(partial-completion))
   :bind (:map vertico-map
     ("C-j" . vertico-next)    ;; Bind C-j to move to the next candidate
     ("C-k" . vertico-previous) ;; Bind C-k to move to the previous candidate
     )

  
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :custom
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode))
(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
;; Replace bindings. Lazily loaded by `use-package'.
:bind (;; C-c bindings in `mode-specific-map'
       ("C-c M-x" . consult-mode-command)
       ("C-c h" . consult-history)
       ("C-c k" . consult-kmacro)
       ("C-c m" . consult-man)
       ("C-c i" . consult-info)
       ([remap Info-search] . consult-info)
       ;; C-x bindings in `ctl-x-map'
       ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
       ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
       ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
       ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
       ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
       ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
       ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
       ;; Custom M-# bindings for fast register access
       ("M-#" . consult-register-load)
       ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
       ("C-M-#" . consult-register)
       ;; Other custom bindings
       ("M-y" . consult-yank-pop)                ;; orig. yank-pop
       ;; M-g bindings in `goto-map'
       ("M-g e" . consult-compile-error)
       ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
       ("M-g g" . consult-goto-line)             ;; orig. goto-line
       ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
       ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
       ("M-g m" . consult-mark)
       ("M-g k" . consult-global-mark)
       ("M-g i" . consult-imenu)
       ("M-g I" . consult-imenu-multi)
       ;; M-s bindings in `search-map'
       ("M-s d" . consult-find)                  ;; Alternative: consult-fd
       ("M-s c" . consult-locate)
       ("M-s g" . consult-grep)
       ("M-s G" . consult-git-grep)
       ("M-s r" . consult-ripgrep)
       ("M-s l" . consult-line)
       ("M-s L" . consult-line-multi)
       ("M-s k" . consult-keep-lines)
       ("M-s u" . consult-focus-lines)
       ;; Isearch integration
       ("M-s e" . consult-isearch-history)
       :map isearch-mode-map
       ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
       ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
       ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
       ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
       ;; Minibuffer history
       :map minibuffer-local-map
       ("M-s" . consult-history)                 ;; orig. next-matching-history-element
       ("M-r" . consult-history))                ;; orig. previous-matching-history-element

;; Enable automatic preview at point in the *Completions* buffer. This is
;; relevant when you use the default completion UI.
:hook (completion-list-mode . consult-preview-at-point-mode)

;; The :init configuration is always executed (Not lazy)
:init

;; Optionally configure the register formatting. This improves the register
;; preview for `consult-register', `consult-register-load',
;; `consult-register-store' and the Emacs built-ins.
(setq register-preview-delay 0.5
      register-preview-function #'consult-register-format)

;; Optionally tweak the register preview window.
;; This adds thin lines, sorting and hides the mode line of the window.
(advice-add #'register-preview :override #'consult-register-window)

;; Use Consult to select xref locations with preview
(setq xref-show-xrefs-function #'consult-xref
      xref-show-definitions-function #'consult-xref)

;; Configure other variables and modes in the :config section,
;; after lazily loading the package.
:config

;; Optionally configure preview. The default value
;; is 'any, such that any key triggers the preview.
;; (setq consult-preview-key 'any)
;; (setq consult-preview-key "M-.")
;; (setq consult-preview-key '("S-<down>" "S-<up>"))
;; For some commands and buffer sources it is useful to configure the
;; :preview-key on a per-command basis using the `consult-customize' macro.
(consult-customize
 consult-theme :preview-key '(:debounce 0.2 any)
 consult-ripgrep consult-git-grep consult-grep
 consult-bookmark consult-recent-file consult-xref
 consult--source-bookmark consult--source-file-register
 consult--source-recent-file consult--source-project-recent-file
 ;; :preview-key "M-."
 :preview-key '(:debounce 0.4 any))

;; Optionally configure the narrowing key.
;; Both < and C-+ work reasonably well.
(setq consult-narrow-key "<") ;; "C-+"

;; Optionally make narrowing help available in the minibuffer.
;; You may want to use `embark-prefix-help-command' or which-key instead.
;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package company
  :config
  (setq company-minimum-prefix-length 1)
  (global-company-mode)
  :bind (:map company-active-map
    ("C-j" . company-select-next-or-abort)
    ("C-k" . company-select-previous-or-abort)
    )
)

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  ;;(setq lsp-keymap-prefix "C-c")
  :hook (
         (python-mode . lsp)
         (c-mode . lsp)
	 )
  :commands lsp
  :config
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-enable-symbol-highlighting nil)
  )
  

  ;; optionally
  (use-package lsp-ui
    :commands
    lsp-ui-mode
    lsp-ui-sideline-mode
    lsp-ui-peek-mode
    lsp-ui-doc-mode
    :config
    (setq lsp-ui-peek-always-show t)
    (setq lsp-ui-doc-position 'at-point)
  	  )
  (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

  ;; optionally if you want to use debugger
  (use-package dap-mode)
  ;; (use-package dap-LANGUAGE) to load the dap adapter for your language

(setq gc-cons-threshold 200000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq lsp-idle-delay 0.0500)
(setq company-idle-delay .0100)  ; Shows suggestions immediately

(defun ex/c-mode-lsp-keybindings ()
  "Define custom keybindings for `c-mode` with `lsp-mode`."
  (when (derived-mode-p 'c-mode)
    (evil-define-key 'normal lsp-mode-map (kbd "gd") 'xref-find-definitions)
    (evil-define-key 'normal lsp-mode-map (kbd "gD") 'lsp-ui-peek-find-definitions)
    (evil-define-key 'normal lsp-mode-map (kbd "C-k") 'lsp-ui-doc-glance)
    ))

;; Add the keybinding function to the lsp-mode hook for C mode
(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'ex/c-mode-lsp-keybindings))

(use-package projectile
:init
(projectile-mode +1)
:bind (:map projectile-mode-map
            ("C-c p" . projectile-command-map)))

(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
  )
(use-package tree-sitter-langs
  :after tree-sitter)

(use-package undo-tree
  :init
  (global-undo-tree-mode)
  :custom
  (undo-tree-visualizer-diff t)
  (undo-tree-visualizer-timestamps t)
  :bind (
    ("M-u" . undo-tree-visualize)
  )
)
  (defun undo-tree-split-side-by-side (original-function &rest args)
  "Split undo-tree side-by-side"
  (let ((split-height-threshold nil)
	  (split-width-threshold 0))
    (apply original-function args)))

(advice-add 'undo-tree-visualize :around #'undo-tree-split-side-by-side)

(evil-set-undo-system 'undo-tree)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
(setq undo-tree-enable-undo-in-region nil)
