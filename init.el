(prefer-coding-system 'utf-8)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat)))
 '(debug-on-error nil)
 '(ibuffer-formats
   (quote
	((mark modified read-only " "
		   (name 35 35 :left :elide)
		   " "
		   (size 9 -1 :right)
		   " "
		   (mode 16 16 :left :elide)
		   " " filename-and-process)
	 (mark " "
		   (name 16 -1)
		   " " filename))))
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("u:/organizer.org")))
 '(org-clock-report-include-clocking-task t)
 '(org-mouse-1-follows-link nil)
 '(org-support-shift-select t)
 '(package-selected-packages
   (quote
	(markdown-mode yaml-mode expand-region origami origami-mode key-chord js2-mode csharp-mode csharp yasnippet which-key web-mode use-package undo-tree try smex projectile powershell multiple-cursors hydra dumb-jump counsel company clojure-mode back-button ag ace-window ace-jump-mode)))
 '(recentf-menu-before "Open File...")
 '(scroll-error-top-bottom nil)
 '(set-mark-command-repeat-pop nil)
 '(shift-select-mode t)
 '(smex-prompt-string "M-x ")
 '(tab-width 4))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(completions-common-part ((t (:inherit default :foreground "red"))))
 '(diredp-ignored-file-name ((t (:foreground "#bebebe"))) t)
 '(highlight ((t (:background "#454545" :foreground "#ffffff" :underline nil))))
 '(org-clock-overlay ((t (:background "dim gray" :foreground "white"))))
 '(region ((t (:background "#666" :foreground "#f6f3e8"))))
 '(show-paren-match ((t (:background "gray21")))))

(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;;(set-face-attribute 'region nil :background "#666")
;;(set-face-attribute 'show-paren-match nil :background "gray21")

;;turn off the tool bar
(tool-bar-mode -1)

;;use spaces instead of tabs
;;(setq-default indent-tabs-mode nil)

(setq show-paren-style 'expression)

;;Show matching paren
(show-paren-mode 1)

(add-to-list 'load-path "~/.emacs.d/lisp/")

;;use windows type mouse stuff
(load "init_mouse")

;;macports puts cert.pem in /opt/local
(when (string-equal system-type "darwin")
  (require 'gnutls)
  (add-to-list 'gnutls-trustfiles "/opt/local/etc/openssl/cert.pem"))

(require 'package)

;;https://emacs.stackexchange.com/questions/2969/is-it-possible-to-use-both-melpa-and-melpa-stable-at-the-same-time
(setq package-archives
	  '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
		("MELPA Stable" . "https://stable.melpa.org/packages/")
		("MELPA"        . "https://melpa.org/packages/"))
	  package-archive-priorities
	  '(("MELPA Stable" . 10)
		("GNU ELPA"     . 5)
		("MELPA"        . 0)))

;;(setq package-enable-at-startup nil) ;;do we need this?
(package-initialize)

(when (string-equal system-type "windows-nt")
  (add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
  (setq ispell-program-name "aspell"))

(setq cb-encrypt-org nil)
(setq cb-add-org-ids nil)
(when (string-equal system-type "gnu/linux")
  (setq cb-encrypt-org t)
  (setq cb-add-org-ids t))

;; for Windows and Mac, set Middle-click to do nothing (it can be customizable by the user)
(when (or (string-equal system-type "windows-nt")
          (string-equal system-type "darwin"))
  (global-set-key [mouse-2] nil))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;;Turn on column number
(column-number-mode 1)

;; Lets user type y and n instead of the full yes and no.
(defalias 'yes-or-no-p 'y-or-n-p)

;;turn on cua mode
(cua-mode t)
(setq cua-keep-region-after-copy t    ;; Standard Windows behaviour
      cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands

(defun esk-pretty-fn ()
  (font-lock-add-keywords nil `(("(\\(\\<fn\\>\\)"
								 (0 (progn (compose-region (match-beginning 1)
														   (match-end 1) "\u0192") nil))))))
(add-hook 'clojure-mode-hook 'esk-pretty-fn)
(add-hook 'clojurescript-mode-hook 'esk-pretty-fn)
(add-hook 'prog-mode-hook
		  (lambda ()
			(font-lock-add-keywords nil
									'(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

;;http://www.emacswiki.org/emacs/WhichFuncMode
(eval-after-load "which-func"
  '(setq which-func-modes '(java-mode c++-mode))
  ;;'(setq which-func-modes '(java-mode c++-mode org-mode))
  )

;; ;; No region when it is not highlighted
;; (transient-mark-mode 1)

;; ;;http://stackoverflow.com/a/7998271 
;; ;; (setq split-width-threshold 1 ) ;;split-window-vertical
;; ;; (setq split-width-threshold nil);;split-window-horizontal

;;save minibuffer history
(savehist-mode 1)

(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t) ;don't clobber symlinks
(setq delete-old-versions t
	  kept-new-versions 6
	  kept-old-versions 2
	  version-control t
	  vc-make-backup-files t) ;; Make backups of files, even when they're in version control

;;http://www.emacswiki.org/emacs/AlarmBell
;;(setq visible-bell 1)           ;; turn on visual bell
(setq ring-bell-function 'ignore) ;;turn off bells 

;;http://stackoverflow.com/a/1128948
;; Smooth scrolling by keys line-by-line
(setq scroll-step            1
      scroll-conservatively  10000)

;; scroll via mouse one line at a time (less "jumpy" than defaults)
;;http://www.emacswiki.org/emacs/SmoothScrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)) ;; one line at a time
      ;;mouse-wheel-progressive-speed nil          ;; don't accelerate scrolling
      mouse-wheel-follow-mouse 't)                 ;; scroll window under mouse

;;https://github.com/vermiculus/sx.el/issues/283
(setq gnutls-min-prime-bits 2048)

;;https://www.gnu.org/software/emacs/manual/html_node/emacs/Saving-Emacs-Sessions.html
(setq desktop-restore-frames nil)

;;http://stackoverflow.com/questions/803812/emacs-reopen-buffers-from-last-session-on-startup
(desktop-save-mode 1)

;; ;;http://emacs.stackexchange.com/a/183
;; ;;(eval-expression (executable-find "git"))
;;(add-to-list 'exec-path "C:/Users/cbean/Desktop/PortableGit-2.10.2/bin")

;;http://stackoverflow.com/questions/50417/how-do-i-get-list-of-recent-files-in-gnu-emacs
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 200)
(recentf-mode 1)

(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
										 try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         ;;try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

(defun ergoemacs-previous-user-buffer ()
  "Switch to the previous user buffer.
User buffers are those whose name does not start with *."
  (interactive)
  (previous-buffer)
  (let ((i 0))
    (while (and (string-equal "*" (substring (buffer-name) 0 1)) (< i 20))
      (setq i (1+ i)) (previous-buffer))))

(defun ergoemacs-next-user-buffer ()
  "Switch to the previous user buffer.
User buffers are those whose name does not start with *."
  (interactive)
  (next-buffer)
  (let ((i 0))
    (while (and (string-equal "*" (substring (buffer-name) 0 1)) (< i 20))
      (setq i (1+ i)) (next-buffer) )))

(defun ergoemacs-kill-line-backward (&optional number)
  "Kill text between the beginning of the line to the cursor position.
If there's no text, delete the previous line ending."
  (interactive "p")
  (if (and (= number 1) (looking-back "\n"))
      (delete-char -1)
    (kill-line (- 1 number))))

(defun ergoemacs-new-empty-buffer ()
  "Opens a new empty buffer."
  (interactive)
  (let ((buf (generate-new-buffer "untitled")))
    (switch-to-buffer buf)
    (funcall (and initial-major-mode))
    (setq buffer-offer-save t)))

;;http://stackoverflow.com/questions/145291/smart-home-in-emacs
(defun cb-smart-beginning-of-line ()
  "Move point to first non-whitespace character or beginning-of-line.
Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line."
  (interactive "^")
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))

;;http://stackoverflow.com/questions/1511737/how-do-you-list-the-active-minor-modes-in-emacs
(defun cb-which-active-modes ()
  "Give a message of which minor modes are enabled in the current buffer."
  (interactive)
  (let ((active-modes))
    (mapc (lambda (mode) (condition-case nil
							 (if (and (symbolp mode) (symbol-value mode))
								 (add-to-list 'active-modes mode))
						   (error nil) ))
          minor-mode-list)
    (message "Active modes are %s" active-modes)))

(defun cb-goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis, otherwise insert %.
  vi style of % jumping to matching brace."
  (interactive "p")
  (message "goto-match-paren")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))))

(defun cb-duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
  If there's no region, the current line will be duplicated. However, if
  there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))

;;used for selected-minor-mode to unselect after copy
(defun cb-copy-and-deselect (N)
  (interactive "p")
  (cua-copy-region nil)
  (keyboard-quit))

(defun cb-open-riemann-config-dir ()
  (interactive)
  (find-file "/plink:cbean@192.168.100.145|sudo:localhost:/etc/riemann/"))

;;https://www.emacswiki.org/emacs/ZapUpToChar
;;load the zap-up-to-char function from share/emacs/25.1/lisp/misc.elc
(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR. \(fn arg char)"
  'interactive)

(defun backwards-zap-to-char (char)
  (interactive "cZap backwards to char: ")
  (zap-up-to-char -1 char))

(use-package counsel
  :defer t
  :bind ("C-x rf" . counsel-recentf)
  :ensure t)

(use-package ivy
  :ensure t
  :diminish ivy-mode)

;;http://cestlaz.github.io/posts/using-emacs-6-swiper/
(use-package swiper
  :ensure try
  :bind ("C-f" . swiper)
  :config
  (ivy-mode 1)
  (define-key ivy-minibuffer-map (kbd "C-f") 'ivy-previous-line-or-history)
  (define-key ivy-minibuffer-map (kbd "<next>") 'ivy-scroll-up-command)
  (define-key ivy-minibuffer-map (kbd "<prior>") 'ivy-scroll-down-command)
  (define-key ivy-minibuffer-map (kbd "<escape>") 'minibuffer-keyboard-quit)
  ;; (define-key ivy-minibuffer-map (kbd "C-g") 'minibuffer-keyboard-quit)
  )

(use-package yasnippet
  :ensure t
  :defer 5
  :diminish (yas-minor-mode . "")
  :config (yas-global-mode 1))

(use-package hi-lock
  :defer t
  :diminish (hi-lock-mode . ""))

(use-package expand-region
  :ensure t
  :defer t)

(use-package undo-tree
  :ensure t
  ;;:diminish undo-tree-mode
  :bind (("C-z" . undo-tree-undo)
		 ("C-y" . undo-tree-redo))
  :init
  (progn	
    (global-undo-tree-mode)
	;;http://www.star.bris.ac.uk/bjm/bjm-starter-init.el
    (defalias 'redo 'undo-tree-redo)
    (defalias 'undo 'undo-tree-undo)
    ))

(use-package web-mode
  :ensure t)

(use-package tramp
  :defer t
  :init
  (when (string-equal system-type "windows-nt")
	(setq tramp-default-method "plink")))

(use-package selected
  :diminish selected-minor-mode
  :config
  (setq selected-org-mode-map (make-sparse-keymap))
  (bind-keys :map selected-keymap  
			 ("q" . selected-off)
			 ("c" . cb-copy-and-deselect)
			 ("x" . cua-cut-region)
			 ;;("u" . upcase-region)
			 ;;("d" . downcase-region)
			 ("w" . count-words-region)
			 ("m" . apply-macro-to-region-lines)
			 ("k" . comment-region)
			 ("u" . uncomment-region)
			 :map selected-org-mode-map
			 ("t" . org-table-convert-region))
  (global-selected-minor-mode t))

;;;https://github.com/justbur/emacs-which-key
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config (which-key-mode))

(use-package clojure-mode
  :bind (:map clojure-mode-map
			  ("<kp-add>" . origami-open-node-recursively)
			  ("C-<kp-add>" . origami-open-all-nodes)
			  ("C-<kp-subtract>" . origami-close-all-nodes)
			  ("<kp-subtract>" . origami-close-node))
  :config
  (add-hook 'clojure-mode-hook
			(lambda ()
			  (origami-mode 1)))
  :ensure t)

(use-package hydra
  :ensure t)

(use-package company
  :ensure t
  ;;:defer t
  :diminish company-mode
  :config (global-company-mode))

(use-package back-button
  :ensure t
  :diminish back-button-mode
  :config
  (back-button-mode 1))

(use-package multiple-cursors
  :ensure t)

(use-package csharp-mode
  :ensure t
  :config  
  (add-hook 'csharp-mode-hook
			(lambda ()
			  (hs-minor-mode 1)
			  (setq indent-tabs-mode nil)
			  )))

;;https://stackoverflow.com/questions/23693847/how-can-i-jump-to-a-definition-without-being-queried-in-emacs
(defun find-tag-under-point (&optional arg)
  (interactive "P")
  (cond ((eq arg 9)
		 (let ((current-prefix-arg nil))
		   (call-interactively 'find-tag)))
		(arg
		 (call-interactively 'find-tag))
		(t
		 (find-tag (find-tag-default)))))

(use-package powershell
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.psm1\\'" . powershell-mode))
  (add-to-list 'auto-mode-alist '("\\.psd1\\'" . powershell-mode))
  :config
  (add-hook 'powershell-mode-hook
			(lambda ()
			  (origami-mode 1)
			  (setq indent-tabs-mode nil) ;;use spaces instead of tabs just for powershell-mode
			  ))
  :bind (:map powershell-mode-map
			  ("<f12>" . dumb-jump-go)
			  ("<kp-add>" . origami-open-node-recursively)
			  ("C-<kp-add>" . origami-open-all-nodes)
			  ("C-<kp-subtract>" . origami-close-all-nodes)
			  ("<kp-subtract>" . origami-close-node)
			  ("M-." . dumb-jump-go)
			  ("M-," . dumb-jump-back)
			  ))

(use-package avy
  :ensure t
  :bind (("M-c" . avy-goto-word-1)
		 ("M-C" . avy-goto-word-1-above))
  :defer t)

(use-package ace-window
  :ensure t
  :bind ("M-O" . ace-window)
  :defer t)

;;https://github.com/abo-abo/swiper/issues/881
;;put most recent commands at the top
(use-package smex
  :ensure t
  ;; :config
  ;; ;;stolen from emacs-starter-kit
  ;; (setq smex-save-file (concat user-emacs-directory ".smex-items"))
  ;; (smex-initialize)
  ;; (global-set-key (kbd "M-a") 'smex)
  )

(use-package dumb-jump
  :ensure t
  :config

  ;;Add Powershell jumping
  (add-to-list 'dumb-jump-find-rules
			   '(:type "function" :supports ("ag" "rg" "grep" "git-grep") :language "powershell"
					   :regex "function\\s+[A-Za-z]*:?JJJ[\\s*\\\(]+"
					   :tests ("function test()" "function test ()" "# function Connect-ToServer([Parameter(Mandatory=$true, Position=0)]")))

  (add-to-list 'dumb-jump-find-rules
			   '(:type "variable" :supports ("ag" "grep" "rg" "git-grep") :language "powershell"
					   :regex "\\s*JJJ\\s*=[^\\n]+" :tests ("$test = 1234") ))
  
  (add-to-list 'dumb-jump-language-file-exts
			   ;;'(:language "powershell" :ext "ps1" :agtype nil :rgtype nil)) ;;no extension filtering
			   ;;'(:language "powershell" :ext "ps1" :agtype "file-search-regex \"\\.ps1$\"" :rgtype nil)) ;; use regex to filter to *.ps1
			   '(:language "powershell" :ext "ps1" :agtype "powershell" :rgtype "ps")) ;;added --powershell to ag.exe
  
  ;; (defadvice dumb-jump-go (before my-dumb-jump-go-advice (&optional opts) activate)
  ;; 	"Push a mark on the stack before jumping"
  ;; 	(push-mark))

  (setq dumb-jump-force-searcher 'rg)
  ;;(setq dumb-jump-debug t)
  
  ;;(print dumb-jump-language-file-exts)
  ;;(print dumb-jump-find-rules)
  )

;;(load "~/.emacs.d/lisp/org-customizations")
;;(use-package org-customizations)

(use-package org
  :ensure t
  :defer t
  :init
  ;;https://emacs.stackexchange.com/questions/26287/move-to-the-beginning-of-a-heading-smartly-in-org-mode/26340
  (setq org-special-ctrl-a/e t)
  :bind (:map org-mode-map
			  ("<f12>" . org-clock-in)
			  ("C-y" . undo-tree-undo)
			  ("<home>" . org-beginning-of-line)
			  ("<end>" . org-end-of-line))
  :config
  (use-package org-bullets)

  (require 'yasnippet)
  (defun yas/org-very-safe-expand ()
    (let ((yas/fallback-behavior 'return-nil)) (yas/expand)))
  
  ;;make yasnippets tab completion work
  (make-variable-buffer-local 'yas/trigger-key)
  (setq yas/trigger-key [tab])
  (add-to-list 'org-tab-first-hook 'yas/org-very-safe-expand)
  (define-key yas/keymap [tab] 'yas/next-field)
  
  ;;(bind-key "<f12>" 'org-clock-in org-mode-map)
  ;;(bind-key "C-c C-x C-r" 'cb-org-clock-report org-mode-map)
  ;;(bind-key "C-y" 'undo-tree-redo org-mode-map)
  
  (use-package hydra
	:config
	(defhydra hydra-x  (:hint nil)
	  "
   _i_: Clock In    _o_: Clock Out    _r_: Report    _j_: Jump to Current
   _p_: Progress    _l_: Log Mode     _e_: Estimate  _q_: Quit
   _w_: Estimate Report
"  
	  ("i" org-clock-in :exit t)
	  ("o" org-clock-out :exit t)
	  ("r" cb-org-clock-report :exit t)
	  ("w" cb-org-estimate-report :exit t)
	  ("j" org-clock-goto :exit t)
	  ("p" (message (saintaardvark-org-clock-todays-total)))
	  ("l" org-agenda-list :exit t)
	  ("e" org-columns :exit t)
	  ("q" nil)))

  (define-key org-mode-map (kbd "<f5>") 'hydra-x/body)
  (setq org-src-fontify-natively t)

  ;;http://emacs.stackexchange.com/questions/9528/is-it-possible-to-remove-emsp-from-clock-report-but-preserve-indentation
  (defun cb-org-clocktable-indent-string (level)
	(if (= level 1)
		""
	  (let ((str "\\"))
		(while (> level 2)
		  (setq level (1- level)
				str (concat str "__")))
		(concat str "__ "))))
  (advice-add 'org-clocktable-indent-string :override #'cb-org-clocktable-indent-string)
    
  (defun cb-add-gpg (s)
	(if cb-encrypt-org
		(format "%s.gpg" s)
	  s))
  
  ;;https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html
  (setq org-agenda-files `(,(cb-add-gpg "~/gtd/inbox.org")
  						   ,(cb-add-gpg "~/gtd/gtd.org")
  						   ,(cb-add-gpg "~/gtd/tickler.org")))
  
  (setq org-capture-templates `(("t" "Todo [inbox]" entry
  								 (file+headline ,(cb-add-gpg "~/gtd/inbox.org") "Tasks")
  								 "* TODO %i%?")
  								("T" "Tickler" entry
  								 (file+headline ,(cb-add-gpg "~/gtd/tickler.org") "Tickler")
  								 "* %i%? \n %T")))

  (setq org-refile-targets `((,(cb-add-gpg "~/gtd/gtd.org") :maxlevel . 3)
							 (,(cb-add-gpg "~/gtd/someday.org") :level . 1)
  							 (,(cb-add-gpg "~/gtd/tickler.org") :maxlevel . 2)))

  (define-key global-map (kbd "C-c a") 'org-agenda)
  (define-key global-map (kbd "C-c c") 'org-capture)
  ;;(setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))

  (setq org-agenda-custom-commands 
  		'(("o" "At the office" tags-todo "@office"
  		   ((org-agenda-overriding-header "Office")))
  		  ("x" "At the office" tags-todo "@office"
  		   ((org-agenda-overriding-header "Office")))))

  (setq org-agenda-custom-commands 
  		'(("o" "At the office" tags-todo "@office"
  		   ((org-agenda-overriding-header "Office")))
  		  ;;https://emacs.stackexchange.com/questions/22077/org-agenda-how-to-show-only-todos-with-deadline
  		  ("1" "Events" agenda "display deadlines and exclude scheduled" (
  																		  (org-agenda-span 'month)
  																		  (org-agenda-time-grid nil)
  																		  (org-agenda-show-all-dates nil)
  																		  ;;(org-agenda-entry-types '(:deadline)) ;; this entry excludes :scheduled
  																		  (org-deadline-warning-days 0)))))

  ;;https://superuser.com/questions/71786/can-i-create-a-link-to-a-specific-email-message-in-outlook
  (org-add-link-type "outlook" 'org-outlook-open)
  (defun org-outlook-open (id)
	(message "HI!")
	"Open the Outlook item identified by ID.  ID should be an Outlook GUID."
	(w32-shell-execute "open" "C:/Program Files (x86)/Microsoft Office/Office16/OUTLOOK.EXE" (concat "outlook:" id)))
  ;;(w32-shell-execute "open" (concat "outlook:" id)))
  ;;OUTLOOK:000000000C6ED12E25E2F449B08398712BCD22650700E12E63147B2F9C4886898B1B1880243F000150A5AC3B0000CA00A73412F32447A1E570BC28CCEB280002026F57B70000

  (setq org-agenda-todo-ignore-scheduled 'future)
  
  ;;Highlight in Yellow the current clocked-in task
  (add-hook 'org-clock-in-hook
			(lambda ()
			  (hi-lock-mode 1)
			  ;; Note: highlight-phrase expects a regex -- if your task has regex characters in it, it won't work all that well.
			  (highlight-phrase (format "%s" org-clock-heading) 'hi-green-b)))

  (add-hook 'org-clock-out-hook
			(lambda ()
			  (hi-lock-mode 0)))

  ;;bullets-mode requires org-mode to be already loaded and the use-package :config doesn't seem to turn it on
  (add-hook 'org-mode-hook
			(lambda ()
			  ;;(which-function-mode 0);;turn off current function in status bar
			  (org-bullets-mode 1)))

  ;;https://stackoverflow.com/questions/13340616/assign-ids-to-every-entry-in-org-mode/16247032#16247032
  (defun my/org-add-ids-to-headlines-in-file ()
	"Add ID properties to all headlines in the current file which do not already have one."
	(interactive)
	(org-map-entries 'org-id-get-create))

  ;; (defun my/org-set-category-to-id ()
  ;; 	(interactive)
  ;; 	(org-element-property "CATEGORY"))
  
  (when cb-add-org-ids
	(add-hook 'org-mode-hook
			  (lambda ()
				(add-hook 'before-save-hook 'my/org-add-ids-to-headlines-in-file nil 'local)))))

(use-package hydra
  :config
  (defhydra hydra-window  (:hint nil)
	"
   _s_: Shrink (horiz)  _G_: Grow (horiz)  _h_: Split - (horiz)
   _S_: Shrink (vert)   _g_: Grow (vert)   _v_: Split | (vert)
   _x_: Close           _a_: Ace Window 
   _q_: Quit
"  
	("S" shrink-window-horizontally)
	("G" enlarge-window-horizontally)
	("s" shrink-window)
	("g" enlarge-window)
	("h" split-window-below)
	("v" split-window-right)
	("x" delete-window)
	("a" ace-window)
	("q" nil)
	))

(use-package hideshow
  :config

  ;;leave namespace (1) and class (2) unindented
  ;;https://github.com/jwiegley/emacs-release/blob/master/lisp/progmodes/hideshow.el#L100
  (defun ttn-hs-hide-level-2 ()
	(interactive)
	(hs-hide-level 2)
	(forward-sexp 1))

  ;;https://coderwall.com/p/u-l0ra/ruby-code-folding-in-emacs
  (add-to-list 'hs-special-modes-alist
			   `(ruby-mode
				 ,(rx (or "def" "class" "module" "do" "{" "[")) ; Block start
				 ,(rx (or "}" "]" "end"))                       ; Block end
				 ,(rx (or "#" "=begin"))                        ; Comment start
				 ruby-forward-sexp nil))

  ;; (add-to-list 'hs-special-modes-alist
  ;; 			 ;;'(powershell-mode "{" "}" "#" nil nil))
  ;; 			   '(powershell-mode "{" "}" "<?#" nil nil))

  (add-to-list 'hs-special-modes-alist
			   '(csharp-mode "{" "}" "/[*/]" nil nil))

  ;; (global-set-key (kbd "<kp-add>") 'hs-show-block)
  ;; (global-set-key (kbd "C-<kp-add>") 'hs-show-all)
  ;; (global-set-key (kbd "C-<kp-subtract>") 'hs-hide-all)
  ;; (global-set-key (kbd "<kp-subtract>") 'hs-hide-block)

  (add-hook 'csharp-mode-hook (lambda()
  								(setq-local hs-hide-all-non-comment-function 'ttn-hs-hide-level-2))))

(use-package ag
  :ensure t)

(use-package projectile
  :ensure t
  :config (setq projectile-completion-system 'ivy)
  (projectile-global-mode))

(use-package magit
  :ensure t
  :defer t)

(use-package js2-mode
  :ensure t)

;;Mac specific stuff
(when (string-equal system-type "darwin")
  (bind-key* "<end>" 'end-of-line)  ; make end do what it's supposed to do
  (setq mac-command-modifier 'meta) ; make cmd do Meta
  (setenv "PATH" (concat (getenv "PATH") ":/opt/local/bin")) ;; allow emacs to find ag installed by macports
  )

;; (setq w32-pass-rwindow-to-system nil)
;; (setq w32-rwindow-modifier 'super) ; Right Windows key

(bind-key "M-2" 'delete-window)
(bind-key "M-3" 'delete-other-windows)

(bind-key "M-$" 'split-window-horizontally)
(bind-key "M-4" 'split-window-vertically)

(bind-key "C-s" 'save-buffer)

;;http://stackoverflow.com/questions/7411920/how-to-bind-search-and-search-repeat-to-c-f-in-emacs
;;(bind-key (kbd "C-f" 'isearch-repeat-forward)
(bind-key "C-o" 'find-file)
;;(bind-key "C-x C-r" 'recentf-open-files)

(bind-key* "C-a" 'mark-whole-buffer)
(bind-key "M-SPC" 'set-mark-command)

(bind-key "C-<next>" 'ergoemacs-next-user-buffer)
(bind-key "C-<prior>" 'ergoemacs-previous-user-buffer)

(bind-key "M-G" 'ergoemacs-kill-line-backward)
(bind-key "M-g" 'kill-line)
(bind-key "C-S-L" 'kill-whole-line)
(bind-key "C-l" 'goto-line)
(bind-key "M-j" 'join-line)

(bind-key "C-w" 'kill-this-buffer)
;;(bind-key "C-n" 'ergoemacs-new-empty-buffer)

(bind-key "M-\\" 'hippie-expand)
(bind-key "C-\\" 'hippie-expand)

(bind-key "<home>" 'cb-smart-beginning-of-line)
(bind-key "C-%" 'cb-goto-match-paren)
(bind-key "C-c d" 'cb-duplicate-current-line-or-region)

(bind-key "C-c w" 'hydra-window/body)

(bind-key "C-@" 'er/expand-region)

(bind-key* "M-a" 'counsel-M-x)

(bind-key* "C-_" 'back-button-global-forward)
(bind-key* "C--" 'back-button-global-backward)

(bind-key* "C-l" 'goto-line)

(bind-keys :prefix-map vs-prefix-map
		   :prefix "C-k"
		   ("C-c" . comment-region)
		   ("C-u" . uncomment-region))

(bind-key "M-b" 'ibuffer)

(bind-key "M-z" 'zap-up-to-char)
(bind-key "M-Z" 'backwards-zap-to-char)

;; (defun cb-launch-powershell()
;;   (interactive)
;;   (start-process "my-process" nil "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.EXE" ))

;; ;;(shell-command (concat "start " (shell-quote-argument "A")))
;; (setq shell-file-name "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.EXE")
;; (print shell-file-name)

(defun run-powershell ()
  "Run powershell"
  (interactive)
  (async-shell-command "start c:/windows/system32/WindowsPowerShell/v1.0/powershell.exe" nil nil))

;;https://zhangda.wordpress.com/2010/02/03/open-the-path-of-the-current-buffer-within-emacs/
;;https://stackoverflow.com/questions/3400884/how-do-i-open-an-explorer-window-in-a-given-directory-from-cmd-exe
(defun open-buffer-path ()
  "Run explorer on the directory of the current buffer."
  (interactive)
  ;;(shell-command (concat "explorer " (replace-regexp-in-string "/" "\\\\" (file-name-directory (buffer-file-name)) t t))))
  (shell-command (concat "start " (file-name-directory (buffer-file-name)))))

;;http://emacsredux.com/blog/2013/03/27/copy-filename-to-the-clipboard/
(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    ((when )hen filename
	 (kill-new filename)
	 (message "Copied buffer file name '%s' to the clipboard." filename))))

(defun remove-readonly-flag ()
  (interactive)
  (if (string-equal system-type "windows-nt")
	  (set-file-modes (buffer-file-name) #o666)
	(shell-command (format "chmod u+w %s" buffer-file-name)))
  (print (file-modes (buffer-file-name)))
  (read-only-mode -1))
;;(find-file "/plink:cbean@192.168.100.145|sudo:localhost:/etc/nginx/sites-enabled/default")


;;https://courses.cs.washington.edu/courses/cse451/10au/tutorials/tutorial_ctags.html
;;http://mattbriggs.net/blog/2012/03/18/awesome-emacs-plugins-ctags/
;;https://gist.github.com/MarkBorcherding/914528
(defun build-ctags ()
  (interactive)
  (message "building project tags")
  (let ((root (replace-regexp-in-string "/$" "" (projectile-project-root))))
	(let ((cmd (concat "u:/src/ctags58/ctags.exe -R --langdef=Powershell --langmap=Powershell:.psm1.ps1 --regex-Powershell=\"/function\s+([a-z]*:)?([a-zA-Z\-]+)/\2/m,method/i\" --regex-Powershell=\"/(\$[a-zA-Z\-]+)/\1/v, variable/i\" --exclude=templates --exclude=library --exclude=logs -e -f " root "/TAGS " root)))	  
	  (message (concat "building for " root "/TAGS"))	
	  ;;(message cmd)
	  (shell-command cmd)
	  (visit-project-tags)
	  (message (concat "tags built successfully for " root )))))

(defun visit-project-tags ()
  (interactive)  
  (let ((tags-file (concat (replace-regexp-in-string "/$" "" (projectile-project-root)) "/TAGS")))
	(message (concat "Loading: " tags-file))
    (visit-tags-table tags-file)
    (message (concat "Loaded " tags-file))))

;; (use-package key-chord
;;   :ensure t
;;   :config
;;   (key-chord-define-global "fg" 'avy-goto-char))

(use-package origami
  :ensure t
  :config
  (add-to-list 'origami-parser-alist '(powershell-mode . origami-c-style-parser))
  ;; (global-set-key (kbd "<kp-add>") 'origami-open-node-recursively)
  ;; (global-set-key (kbd "C-<kp-add>") 'origami-open-all-nodes)
  ;; (global-set-key (kbd "C-<kp-subtract>") 'origami-close-all-nodes)
  ;; (global-set-key (kbd "<kp-subtract>") 'origami-close-node)
  
  ;;origami-parsers.el:
  ;; (defun origami-clj-parser (create)
  ;;   ;;(origami-lisp-parser create "(def\\(\\w\\|-\\)*\\s-*\\(\\s_\\|\\w\\|[?!]\\)*\\([ \\t]*\\[.*?\\]\\)?"))
  ;;   ;;(origami-lisp-parser create "(def\\w*\\s+"))
  ;;   (origami-lisp-parser create "(def\\w*\\s-[a-z-0-9]+"))
  )

(bind-keys :map emacs-lisp-mode-map
		   ("<kp-add>" . hs-show-block)
		   ("C-<kp-add>" . hs-show-all)
		   ("C-<kp-subtract>" . hs-hide-all)
		   ("<kp-subtract>" . hs-hide-block))

(use-package yaml-mode
  :ensure t)

(use-package markdown-mode
  :ensure t)

;;builtin
;; (use-package winner-mode)

;; (use-package workgroups-mode
;;   :ensure t)

;;https://superuser.com/questions/389303/how-can-i-write-a-emacs-command-that-inserts-a-text-with-a-variable-string-at-th
;;https://mail.google.com/mail/u/0/#inbox/15d1aa7b18f8842c => https://mail.google.com/mail/u/0/#all/15d1aa7b18f8842c
(defun format-gmail-org-link ()
  (interactive)
  (let* ((bounds (bounds-of-thing-at-point 'url))
         (text  (thing-at-point 'url)))
    (when bounds
      (delete-region (car bounds) (cdr bounds))
      (insert "[[" (replace-regexp-in-string "/#inbox/" "/#all/" text) "][Link]]"))))

(when (file-exists-p "~/src/ledger/lisp/ledger-mode.el")  
  (add-to-list 'load-path "~/src/ledger/lisp")

  (use-package ledger-mode
	:config
	(add-to-list 'auto-mode-alist '("\\.ledger\\'" . ledger-mode))
	(add-hook 'ledger-mode-hook (lambda ()
								  (progn
									;;(print "1AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
									;;(make-local-variable 'jit-lock-chunk-size)
									(setq jit-lock-chunk-size 4096); was 500 -- increase to handle large Budget block at the top of the file
									(setq indent-tabs-mode nil)
									;;(print "2AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"))
									)
								  nil 'make-it-local))

	(defun ledger-narrow-to-account ()
	  (interactive)
	  (let ((i 0) (j 0))
		(search-forward ";----")
		(beginning-of-line)
		(setq i (point))
		
		(search-backward ";----")
		(beginning-of-line)
		(setq j (point))
		
		(narrow-to-region i j)))))

;;https://www.emacswiki.org/emacs/SurroundRegion
(defun surround (begin end open close)
  "Put OPEN at START and CLOSE at END of the region.
If you omit CLOSE, it will reuse OPEN."
  (interactive  "r\nsStart: \nsEnd: ")
  (when (string= close "")
    (setq close open))
  (save-excursion
    (goto-char end)
    (insert close)
    (goto-char begin)
    (insert open)))
