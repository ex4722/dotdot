(setq inhibit-startup-message t)
(setq user-full-name "Eddie Xiao"
      user-mail-address "eddie.j.xiao@gmail.com")

(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font Mono" :height 158)

(tool-bar-mode -1)
(menu-bar-mode -1) 
(toggle-scroll-bar -1)
(scroll-bar-mode 0)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror 'nomessage)

(require 'package)
  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
			   ("org" . "https://orgmode.org/elpa/")
			   ("elpa" . "https://elpa.gnu.org/packages/")
			  ("melpa-stable" . "http://stable.melpa.org/packages/") 
))
  (package-initialize)
  (unless package-archive-contents
    (package-refresh-contents))

  (unless (package-installed-p 'use-package)
    (package-install 'use-package))

  (require 'use-package)
  (setq use-package-always-ensure t)

(defalias 'yes-or-no-p 'y-or-n-p)

(column-number-mode)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.emacs.d/backup"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

;; (tab-bar-mode 1)
;; (setq tab-bar-close-button-show nil

;; tab-bar-button-relief 0)

;; (use-package centaur-tabs     
;; :demand
;; :config
;; (centaur-tabs-mode t)
;; :bind
;; ("C-<prior>" . centaur-tabs-backward)
;; ("C-<next>" . centaur-tabs-forward))

(use-package perspective
  :bind
  (("C-x C-b" . persp-counsel-switch-buffer)         ; or use a nicer switcher, see below

   ("M-1" . (lambda () (interactive) (persp-switch-by-number 1)))
   ("M-2" . (lambda () (interactive) (persp-switch-by-number 2)))
   ("M-3" . (lambda () (interactive) (persp-switch-by-number 3)))
   ("M-4" . (lambda () (interactive) (persp-switch-by-number 4)))
   ("M-5" . (lambda () (interactive) (persp-switch-by-number 5)))
   )

  :custom
  (persp-mode-prefix-key (kbd "C-c C-p"))  ; pick your own prefix key here, might never use 
  :init
  (persp-mode))

(use-package persp-projectile)

(use-package general
  :config
  (general-auto-unbind-keys nil)
  (general-create-definer ex/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-evil-setup))

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

(remove-hook 'tty-setup-hook 'doom-init-clipboard-in-tty-emacs-h)

; (setq-default evil-escape-key-sequence "jk")
(general-imap "j"
  (general-key-dispatch 'self-insert-command
    :timeout 0.1
    "k" 'evil-normal-state))

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
  (setq select-enable-clipboard nil))

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

(use-package  ivy-posframe
  :ensure t
  :config
  (setq ivy-posframe-min-width 150
	ivy-posframe-width 150)
  (setq ivy-posframe-height-alist '((swiper . 20)
				    (t      . 15)))
  :init
  (ivy-posframe-mode))

(defun my/ivy-posframe-display-at-frame-bottom-center (str)
  (interactive)
  (ivy-posframe--display str #'posframe-poshandler-frame-bottom-center))

(setq ivy-posframe-display-functions-alist
      '((t . my/ivy-posframe-display-at-frame-bottom-center)))

;; (set-face-attribute 'ivy-posframe nil :foreground "white")

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

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

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
  :bind
  (("C-x b" . counsel-projectile-switch-to-buffer)
   )
  )
(use-package magit)
(use-package forge)

(use-package org
  :config

(setq org-hide-emphasis-markers t)

(setq org-ellipsis " ▾")

(setq org-agenda-files
	  '("~/life/tasks.org" "~/life/events.org" "~/life/refile.org" "~/life/school.org" "~/orgfiles/journal.org")
)
(setq org-agenda-window-setup 'only-window)

(setq org-log-done 'time)

(global-set-key (kbd "C-c a") 'org-agenda)
;; (define-key org-mode-map (kbd "S-<return>") nil)
;; (global-set-key (kbd "S-<return>") 'org-ctrl-c-ret)

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "SOMD(s)" "WAFO(w)" "|" "DONE(d!)")
	(sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

;; (setq org-todo-keywords
    ;; '((sequence "TODO(t!)" "NEXT(n)" "SOMD(s)" "WAFO(w)" "|" "DONE(d!)" "CANC(c!)")))

(setq org-agenda-custom-commands
		    '(("d" "Dashboard"
		       ((agenda "" ((org-deadline-warning-days 7) ))
			(todo "NEXT"
			      ((org-agenda-overriding-header "Next Tasks")))
			(tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))
("a" "Daily agenda and top priority tasks"
       ((tags-todo "*"
		   ((org-agenda-skip-function '(org-agenda-skip-if nil '(timestamp)))
		    (org-agenda-skip-function
		     `(org-agenda-skip-entry-if
		       'notregexp ,(format "\\[#%s\\]" (char-to-string org-priority-highest))))
		    (org-agenda-block-separator nil)
		    (org-agenda-overriding-header "Important tasks without a date\n")))
	(agenda "" ((org-agenda-span 1)
		    (org-deadline-warning-days 0)
		    (org-agenda-block-separator nil)
		    (org-scheduled-past-days 0)
		    ;; We don't need the `org-agenda-date-today'
		    ;; highlight because that only has a practical
		    ;; utility in multi-day views.
		    (org-agenda-day-face-function (lambda (date) 'org-agenda-date))
		    (org-agenda-format-date "%A %-e %B %Y")
		    (org-agenda-overriding-header "\nToday's agenda\n")))
	(agenda "" ((org-agenda-start-on-weekday nil)
		    (org-agenda-start-day "+1d")
		    (org-agenda-span 3)
		    (org-deadline-warning-days 0)
		    (org-agenda-block-separator nil)
		    (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
		    (org-agenda-overriding-header "\nNext three days\n")))
	(agenda "" ((org-agenda-time-grid nil)
		    (org-agenda-start-on-weekday nil)
		    ;; We don't want to replicate the previous section's
		    ;; three days, so we start counting from the day after.
		    (org-agenda-start-day "+4d")
		    (org-agenda-span 14)
		    (org-agenda-show-all-dates nil)
		    (org-deadline-warning-days 0)
		    (org-agenda-block-separator nil)
		    (org-agenda-entry-types '(:deadline))
		    (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
		    (org-agenda-overriding-header "\nUpcoming deadlines (+14d)\n")))))

		      ("n" "Next Tasks"
		       ((todo "NEXT"
			      ((org-agenda-overriding-header "Next Tasks")))))

		      ("c" "Today Only"
		(
	  (agenda ""
  ((org-agenda-span 1)
(org-agenda-day-face-function (lambda (date) 'org-agenda-date))) )
    ))
("x" "Not scheduled yet"
   ( (todo "TODO"
           (
            (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline 'timestamp 'regexp "desparche"                                                               ))
            )
           )
     )
   )

						      ; ("W" "Work Tasks" tags-todo "+work-email")

		      ;; Low-effort next actions
		      ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
		       ((org-agenda-overriding-header "Low Effort Tasks")
			(org-agenda-max-todos 20)
			(org-agenda-files org-agenda-files)))

		      ("w" "Workflow Status"
		       ((todo "WAIT"
			      ((org-agenda-overriding-header "Waiting on External")
			       (org-agenda-files org-agenda-files)))
			(todo "REVIEW"
			      ((org-agenda-overriding-header "In Review")
			       (org-agenda-files org-agenda-files)))
			(todo "PLAN"
			      ((org-agenda-overriding-header "In Planning")
			       (org-agenda-todo-list-sublevels nil)
			       (org-agenda-files org-agenda-files)))
			(todo "BACKLOG"
			      ((org-agenda-overriding-header "Project Backlog")
			       (org-agenda-todo-list-sublevels nil)
			       (org-agenda-files org-agenda-files)))
			(todo "READY"
			      ((org-agenda-overriding-header "Ready for Work")
			       (org-agenda-files org-agenda-files)))
			(todo "ACTIVE"
			      ((org-agenda-overriding-header "Active Projects")
			       (org-agenda-files org-agenda-files)))
			(todo "COMPLETED"
			      ((org-agenda-overriding-header "Completed Projects")
			       (org-agenda-files org-agenda-files)))
			(todo "CANC"
			      ((org-agenda-overriding-header "Cancelled Projects")
			       (org-agenda-files org-agenda-files))))))))

(setq org-tag-alist
      '((:startgroup)
					; Put mutually exclusive tags here
	(:endgroup)
	("@errand" . ?e)
	("@school" . ?s)
	("@work" . ?w)
	("@hacking" . ?h)
	("@personal". ?p)
	("@planning" . ?P)
	("idea" . ?i)
	("note" . ?n))
      )

(setq org-refile-targets
	 '(("~/life/archive.org" :maxlevel . 2)
	   ("~/life/tasks.org" :maxlevel . 2)
("~/life/events.org" :maxlevel . 2)
  ))

   ;; Save Org buffers after refiling!
   (advice-add 'org-refile :after 'org-save-all-org-buffers)

(setq org-capture-templates
	  `(("t" "Tasks / Projects")
	    ("tt" "Task" entry (file+olp "~/life/refile.org" "Inbox")
	     "* TODO  %?\n  %U\n" :kill-buffer t :empty-lines 1 )
	    ("tw" "Linked Task" entry (file+olp "~/life/refile.org" "Inbox")
	     "* TODO  %?\n  %U\n %a\n  %i" :kill-buffer t :empty-lines 1 )

	    ("e" "Event" entry (file+olp "~/life/events.org" "Events")
	     "*  %?\n  %U\n" :kill-buffer t :empty-lines 1 )

	    ("j" "Journal Entries")
	    ("jj" "Journal" entry
	     (file+olp+datetree "~/orgfiles/journal.org")
	     "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
	     ;; ,(dw/read-file-as-string "~/Notes/Templates/Daily.org")
	     :clock-in :clock-resume
	     :empty-lines 1)
	    ("jm" "Morning Journal" entry
	     (file+olp+datetree "~/orgfiles/journal.org")
	     "\n* %<%I:%M %p> - Journal :journal:\n%?\n** Morning Entry\n*** Looking Forward To\n*** Day Plan\n*** Misc"
	     :clock-in :clock-resume
	     :empty-lines 1)
	  ("m" "Metrics Capture")
	("mw" "Weight" table-line (file+headline "~/Projects/Code/emacs-from-scratch/OrgFiles/Metrics.org" "Weight")
	 "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)
))

(require 'org-habit)
  (add-to-list 'org-modules 'org-habit t)
  (setq org-treat-insert-todo-heading-as-state-change t)
  ;; log into LOGBOOK drawer
  (setq org-log-into-drawer t)

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



(use-package emacsql)
	    (use-package emacsql-sqlite)
	    (use-package org-roam
		;; :hook 
		;; (after-init . org-roam-mode)
		:custom
		(org-roam-directory "~/life/roam")
		(org-roam-completion-everywhere t)
		:bind 
		    (("C-c n l" . org-roam)
			 ;; ("C-c n f" . org-roam-find-file)
			 ("C-c n f" . org-roam-node-find)
			 ("C-c n i" .  org-roam-node-insert-immediate)
			 ("C-c n l" . org-roam-buffer-toggle)

			 ("C-c n b" . org-roam-switch-to-buffer)
			 ("C-c n g" . org-roam-graph-show)
			 ("C-c n a" . org-roam-alias-add)
	       :map org-mode-map
	   ("C-M-i"    . completion-at-point))
  :bind-keymap
("C-c n d" . org-roam-dailies-map)
	  :config
	  (org-roam-db-autosync-mode)
      )
    ;; types of tempate, fleeing, literature, permendent 
	(setq org-roam-capture-templates
      '(("f" "Fleeing default" plain "* Context:\n%?" :target
      (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
      :unnarrowed t :kill-buffer t)
  ("l" "Literature" plain "* Context:\n%?\n* References: \n\n" :target
	  (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
	  :unnarrowed t :kill-buffer t)
  ("p" "Permendant" plain "* Context:\n%?\n* References: \n\n" :target
	  (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+date: %U\n")
	  :unnarrowed t :kill-buffer t)
) )

    (defun org-roam-node-insert-immediate (arg &rest args)
    (interactive "P")
    (let ((args (cons arg args))
	  (org-roam-capture-templates (list (append (car org-roam-capture-templates)
						    '(:immediate-finish t)))))
      (apply #'org-roam-node-insert args)))

    (defun org-roam-node-find-immediate (arg &rest args)
    (interactive "P")
    (let ((args (cons arg args))
	  (org-roam-capture-templates (list (append (car org-roam-capture-templates)
						    '(:immediate-finish t)))))
      (apply #'org-roam-node-find args)))

      (use-package org-roam-ui
      ;; :straight
      ;;   (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
	:after org-roam
    ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
    ;;         a hookable mode anymore, you're advised to pick something yourself
    ;;         if you don't care about startup time, use
    ;;  :hook (after-init . org-roam-ui-mode)
	:config
	(setq org-roam-ui-sync-theme t
	      org-roam-ui-follow t
	      org-roam-ui-update-on-save t
	      org-roam-ui-open-on-start t))

;;     (defun +org-notes-tags-read ()
;;       "Return list of tags as set in the buffer."
;;       (org-roam--extract-tags-prop (buffer-file-name (buffer-base-buffer))))
;;   (defun +org-notes-tags-delete ()
;;     "Delete a tag from current note."
;;     (interactive)
;;     (unless (+org-notes-buffer-p)
;;       (user-error "Current buffer is not a note"))
;;     (let* ((tags (+org-notes-tags-read))
;; 	   (tag (completing-read "Tag: " tags nil 'require-match)))
;;       (+org-buffer-prop-set
;;        "ROAM_TAGS"
;;        (combine-and-quote-strings (delete tag tags)))
;;       (org-roam-db--update-tags)))
;;    (defun +org-notes-tags-add ()
;;   "Add a tag to current note."
;;   (interactive)
;;   (unless (+org-notes-buffer-p)
;;     (user-error "Current buffer is not a note"))
;;   (let* ((tags (seq-uniq
;; 		(+seq-flatten
;; 		 (+seq-flatten
;; 		  (org-roam-db-query [:select tags :from tags])))))
;; 	 (tag (completing-read "Tag: " tags)))
;;     (when (string-empty-p tag)
;;       (user-error "Tag can't be empty"))
;;     (+org-buffer-prop-set
;;      "ROAM_TAGS"
;;      (combine-and-quote-strings (seq-uniq (cons tag (+org-notes-tags-read)))))
;;     (org-roam-db--update-tags)))
;;   (defun +org-notes-buffer-p ()
;;   "Return non-nil if the currently visited buffer is a note."
;;   (and buffer-file-name
;;        (string-equal (file-name-as-directory org-roam-directory)
;;                      (file-name-directory buffer-file-name))))

;; (defun +seq-flatten (list-of-lists)
;;   "Flatten LIST-OF-LISTS."
;;   (apply #'append list-of-lists))

;; (defun +org-buffer-prop-set (name value)
;;   "Set a buffer property called NAME to VALUE."
;;   (save-excursion
;;     (widen)
;;     (goto-char (point-min))
;;     (if (re-search-forward (concat "^#\\+" name ": \\(.*\\)") (point-max) t)
;;         (replace-match (concat "#+" name ": " value))
;;       ;; find the first line that doesn't begin with ':' or '#'
;;       (let ((found))
;;         (while (not (or found (eobp)))
;;           (beginning-of-line)
;;           (if (or (looking-at "^#")
;;                   (looking-at "^:"))
;;               (line-move 1 t)
;;             (setq found t)))
;;         (insert "#+" name ": " value "\n")))))



(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)))

(setq org-babel-python-command "python3")
(setq org-confirm-babel-evaluate nil)
(push '("conf-unix" . conf-unix) org-src-lang-modes)

;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when ( or (string-equal (buffer-file-name)
			   (expand-file-name "~/.emacs.d/init.org")

			   ) (string-equal (buffer-file-name) (expand-file-name "/opt/dotdot/emacs/.emacs.d/init.org"))
			     )
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))
(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
  )
(use-package tree-sitter-langs
  :after tree-sitter)

(use-package lsp-mode
  ;; :init (setq lsp-keymap-prefix "SPC")
  :hook (prog-mode . lsp-mode)
  (lsp-mode . lsp-enable-which-key-integration)
  :commands lsp
  :config
  (lsp-enable-which-key-integration t)
  (define-key evil-normal-state-map "g" nil)

  (define-key evil-normal-state-map (kbd "C-c e") lsp-command-map)
  (define-key evil-normal-state-map (kbd "gr") #'lsp-rename)
  (define-key evil-normal-state-map (kbd "gd") #'lsp-find-definition)
  (define-key evil-normal-state-map (kbd "gD") #'lsp-ui-peek-find-definitions)
  (define-key evil-normal-state-map (kbd "K") #'lsp-signature-activate)
  (define-key evil-normal-state-map (kbd "C-k") 'lsp-ui-doc-show)
  :bind(
	;; ("gD" . lsp-ui-peek-find-definitions)
	;; ("gr" . lsp-rename)
	)
  )
					; Hover over tab to highlight all occurances
(setq lsp-enable-symbol-highlighting nil)
					; Cursor on func shows info
(setq lsp-ui-doc-enable nil)

					; no clue what this is
(setq lsp-lens-enable t)
					; gtfo breadline
(setq lsp-headerline-breadcrumb-enable nil)

					; Show crap on the right but no code actions
(setq lsp-ui-sideline-enable t)
(setq lsp-ui-sideline-show-code-actions nil)
					; Should get rid of swiggly lines??
(setq lsp-diagnostics-provider :none)
					; Virtual Text, Not workign ??
(setq lsp-ui-sideline-enable nil)
					; Doc on bottem?
(setq lsp-eldoc-enable-hover t)
					; lsp-signature-activate
(setq lsp-signature-auto-activate t) 
(setq lsp-signature-render-documentation t)

(setq lsp-completion-provider :company)

					; Might nil this, kinda verbose and useless
(setq lsp-completion-show-detail t)
(setq lsp-completion-show-kind t)

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
			 (require 'lsp-pyright)
			 (lsp))))  ; or lsp-deferred

(setq lsp-ui-peek-always-show t)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
	      ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
	("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (add-hook 'after-init-hook 'global-company-mode)  
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol
  )

(use-package evil-nerd-commenter
  :config
  (define-key evil-normal-state-map (kbd "gc")  'evilnc-comment-or-uncomment-lines )
  )

(use-package posframe)
(setq lsp-signature-function 'lsp-signature-posframe)
;; (setq lsp-ui-doc-render-function 'lsp-signature-posframe)
(setq lsp-ui-doc-position 'at-point)

(add-hook 'lsp-ui-doc-frame-mode-hook #'(lambda()(display-line-numbers-mode -1)))

(ex/leader-keys
  "p" '(:keymap projectile-command-map :wk "projectile prefix")
  ;; "g" '(:keymap lsp-command-map :wk "Lsp")
  "g" '(magit-status :which-key "Magit")
  ;; "a" '(org-agenda :which-key "Agenda")
  "c" '(org-capture :which-key "Capture")
  "r" '(org-roam-capture :which-key "Roam Capture")
  "i" '(my-edit-configuration :which-key "Edit init.org")
  )

(defun reload ()
  (interactive)
  (message "reloading crap")
  (load-file "/home/ex/.emacs.d/init.el")
  )
(global-set-key (kbd "C-S-r") 'reload)

(defun my-edit-configuration ()
  "Open the init file."
  (interactive)
  (find-file "/home/ex/.emacs.d/init.org"))

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

;; (setq plstore-cache-passphrase-for-symmetric-encryption t)
;; (require 'org-gcal)
;; (setq org-gcal-client-id "254401136944-c0mj3o48gsf7gv7s61laj1jvlpla2eki.apps.googleusercontent.com"
;; 	org-gcal-client-secret "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"
;; 	org-gcal-file-alist '(("thy.isnis@gmail.com" .  "/tmp/schedules.org"))
;; )

(use-package org-caldav
:custom
  ; (org-caldav-url "https://calendar.google.com/calendar/ical/thy.isnis%40gmail.com/private-3b6536adac15d46871df4e76b05eef1a/basic.ics")
(org-caldav-calendar-id "254401136944-c0mj3o48gsf7gv7s61laj1jvlpla2eki.apps.googleusercontent.com")
(org-caldav-inbox "/tmp/schedule.org")
(org-caldav-oauth2-client-id "254401136944-c0mj3o48gsf7gv7s61laj1jvlpla2eki.apps.googleusercontent.com")
(org-caldav-oauth2-client-secret "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")
(org-caldav-url 'google)
(org-caldav-calendar-id "thy.isnis@gmail.com")
)

(setq bnb/calfw-calendars-list nil)

      (defun bnb/add-calendar (calendar)
	(add-to-list bnb/calfw-calendars-list calendar))

      (use-package sunshine
	  :ensure t
	  :commands (bnb/get-forecast-data)
	  :config
	  (defun bnb/get-forecast-data (b e)
	    (let* ((url (sunshine-make-url sunshine-location sunshine-units sunshine-appid))
		   (forecast (if (sunshine-forecast-cache-expired url)
				 (with-current-buffer (url-retrieve-synchronously url)
				   (goto-char (point-min))
				   (sunshine-extract-response))
			       (with-temp-buffer
				 (mm-disable-multibyte)
				 (url-cache-extract (url-cache-create-filename url))
				 (sunshine-extract-response)))))
	      (cl-loop for day across (cdr (assoc 'list forecast)) collect
		       (make-cfw:event
			:title (format "%s/%s°, %s"
				       (round (cdr (assoc 'min (cdr (assoc 'temp day)))))
				       (round (cdr (assoc 'max (cdr (assoc 'temp day)))))
				       (cdr (assoc 'main (elt (cdr (assoc 'weather day)) 0))))
			:start-date (cfw:emacs-to-calendar (seconds-to-time (cdr (assoc 'dt day))))))))
    :custom
    (sunshine-location "11219,USA")
    (sunshine-appid "84a3f397fc4a4d292c608c96e8167222")
    )

      (use-package calfw
	:ensure t
	:bind (
	      ("C-c n c" . cfw:open-org-calendar)
	  )
)
	(use-package calfw-cal)
	(use-package calfw-ical)
	(use-package calfw-org)
	(use-package calfw-ical)
	;; (setq cfw:render-line-breaker cfw:render-line-breaker-none)

  (defun my-open-calendar ()
    (interactive)
    (cfw:open-calendar-buffer
     :contents-sources
     (list
      (cfw:org-create-source "Green")  ; orgmode source
      (cfw:cal-create-source "Orange") ; diary source
      (cfw:ical-create-source "gcal" "https://calendar.google.com/calendar/ical/thy.isnis%40gmail.com/private-3b6536adac15d46871df4e76b05eef1a/basic.ics" "IndianRed") ; google calendar ICS
     ))) 

(custom-set-faces
 '(cfw:face-title ((t (:foreground "#268bd2" :weight bold :height 2.0 :inherit variable-pitch))))
 '(cfw:face-header ((t (:foreground "#657b83" :weight bold))))
 '(cfw:face-sunday ((t :foreground "#657b83" :weight bold)))
 '(cfw:face-saturday ((t :foreground "#657b83"  :weight bold)))
 '(cfw:face-holiday ((t :background "#073642" :weight bold)))
 '(cfw:face-grid ((t :foreground "#586e75")))
 '(cfw:face-default-content ((t :foreground "#bfebbf")))
 '(cfw:face-periods ((t :foreground "cyan")))
 '(cfw:face-day-title ((t :background "#073642")))
 '(cfw:face-default-day ((t :weight bold :inherit cfw:face-day-title)))
 '(cfw:face-annotation ((t :foreground "red" :inherit cfw:face-day-title)))
 '(cfw:face-disable ((t :foreground "#657b83" :inherit cfw:face-day-title)))
 '(cfw:face-today-title ((t :background "#d33682" :weight bold)))
 '(cfw:face-today ((t :background: "#d33682" :weight bold)))
 '(cfw:face-select ((t :background "#268bd2")))
 '(cfw:face-toolbar ((t :foreground "#657b83" :background "#002b36")))
 '(cfw:face-toolbar-button-off ((t :foreground "#6c71c4" :weight bold)))
 '(cfw:face-toolbar-button-on ((t :foreground "#6c71c4" :weight bold))))
(setq frame-resize-pixelwise t)
