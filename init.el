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
 '(org-clock-report-include-clocking-task t)
 '(org-mouse-1-follows-link nil)
 '(org-support-shift-select t)
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

;;turn off the tool bar
(tool-bar-mode -1)

;;use spaces instead of tabs
;;(setq-default indent-tabs-mode nil)

;;https://emacs.stackexchange.com/questions/10837/how-to-make-company-mode-be-case-sensitive-on-plain-text
(setq company-dabbrev-downcase nil)

(setq show-paren-style 'expression)

;;Show matching paren
(show-paren-mode 1)

(add-to-list 'load-path "~/.emacs.d/lisp/")

;;use windows type mouse stuff
(load "init_mouse")

(load "org-table-comment")

(let ((bootstrap-file (concat user-emacs-directory "straight/repos/straight.el/bootstrap.el"))
	  (bootstrap-version 3))
  (unless (file-exists-p bootstrap-file)
	(with-current-buffer
		(url-retrieve-synchronously
		 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
		 'silent 'inhibit-cookies)
	  (goto-char (point-max))
	  (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;macports puts cert.pem in /opt/local
(when (string-equal system-type "darwin")
  (require 'gnutls)
  (add-to-list 'gnutls-trustfiles "/opt/local/etc/openssl/cert.pem"))

(when (string-equal system-type "windows-nt")
  (add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
  (setq ispell-program-name "aspell"))

;; for Windows and Mac, set Middle-click to do nothing (it can be customizable by the user)
(when (or (string-equal system-type "windows-nt")
		  (string-equal system-type "darwin"))
  (global-set-key [mouse-2] nil))

;;(unless (package-installed-p 'use-package)
;;  (package-refresh-contents)
;;  (package-install 'use-package))


;;PS AppData\.emacs.d\straight\repos > $tags=@();foreach ($dir in ls) { cd $dir.FullName; $x=$(git describe --tags 2> $null); "$dir <$x>" }; cd ..
;;                                     $tags=@();foreach ($dir in ls) { cd $dir.FullName; $x=$(git describe --tags 2> $null); $tags += "$dir <$x>"; cd .. }; $tags > freeze-2018-10-24.txt
;;PS AppData\.emacs.d\straight\repos > foreach ($dir in ls) { cd $dir.FullName; git checkout master; git pull }; cd ..
(straight-use-package 'use-package)

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

;; ;;http://stackoverflow.com/a/7998271
;; ;; (setq split-width-threshold 1 ) ;;split-window-vertical
;; ;; (setq split-width-threshold nil);;split-window-horizontal

;;save minibuffer history
(savehist-mode 1)

(setq backup-directory-alist `(("." . "~/.saves/")))
(setq auto-save-file-name-transforms `((".*" "~/.saves/" t)))
;;auto-save-list-file-prefix ;;=> "~/.emacs.d/auto-save-list/.saves-"
(setq create-lockfiles nil)

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

(defun is-temp-buffer (b)
  (or
   (s-starts-with-p " *" (buffer-name b))
   (s-starts-with-p "*" (buffer-name b))))

(defun revert-all-buffers ()
  "Revert all non-temporary buffers asking for permission for modified buffers"
  (interactive)
  (-map (lambda (b)
		  (if (and
			   (buffer-modified-p b)
			   (not (is-temp-buffer b)))
			  (progn
				;;(print (s-concat "Reverting: " (buffer-name b)))
				(set-buffer b)
				(revert-buffer b))) ;; ask
		  (if (and
			   (not (is-temp-buffer b))
			   (not (buffer-modified-p b)))
			  (progn
				;;(print (s-concat "Reverting: " (buffer-name b)))
				(set-buffer b)
				(revert-buffer t t t)))) ;; don't ask
		(buffer-list)))

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

(defun show-buffer-path ()
  "Print the current buffer path in the M-X window."
  (interactive)
  (print (buffer-file-name)))

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

;;https://github.com/raxod502/straight.el/issues/262
;; Inspired by `magit-version'
(defun chunyang-straight-git-version (package)
  (interactive

   (list
	(straight--select-package "Package" nil 'installed)))
  (let ((recipe (gethash package straight--recipe-cache))
		version)
	(straight--with-plist recipe
		(local-repo type)
	  (when (and (eq type 'git) local-repo)
		(let ((default-directory (straight--repos-dir local-repo)))
		  (setq version (or (magit-git-string "describe" "--tags" "--dirty")
							(magit-rev-parse "--short" "HEAD")))
		  (message "%s %s" (upcase-initials package) version)
		  version)))))


;;(chunyang-straight-git-version "magit")
;;=> "2.11.0-584-g4eb84d44"

;;(map-keys straight--recipe-cache)

;;https://www.gnu.org/software/emacs/manual/html_node/eintr/Every.html
(defun print-elements-recursively (list)
  "Print each element of LIST on a line of its own.
	 Uses recursion."
  (when list                            ; do-again-test
	(chunyang-straight-git-version (car list))
	;;(message (car list))              ; body
	(print-elements-recursively     ; recursive call
	 (cdr list)))                  ; next-step-expression
  )
;; Run m-x magit-version to load magit before using
;;(print-elements-recursively (map-keys straight--recipe-cache))

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

;;https://stackoverflow.com/questions/9688748/emacs-comment-uncomment-current-line
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
	(if (region-active-p)
		(setq beg (region-beginning) end (region-end))
	  (setq beg (line-beginning-position) end (line-end-position)))
	(comment-or-uncomment-region beg end)))

(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
					  default-directory
					(buffer-file-name))))
	(when filename
	  (kill-new filename)
	  (message "Copied buffer file name '%s' to the clipboard." filename))))

;; (defun cb-launch-powershell()
;;   (interactive)
;;   (start-process "my-process" nil "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.EXE" ))

(use-package counsel
  :straight (:host github :repo "sideproject/swiper" :branch "navigation" :files ("counsel.el"))
  :defer t
  :bind ("C-x rf" . counsel-recentf))

(use-package ivy
  :straight (:host github :repo "sideproject/swiper" :branch "navigation"
				   :files (:defaults
						   (:exclude "swiper.el" "counsel.el" "ivy-hydra.el")
						   "doc/ivy-help.org"))
  :diminish ivy-mode)

;;http://cestlaz.github.io/posts/using-emacs-6-swiper/
(use-package swiper
  :straight (:host github :repo "sideproject/swiper" :branch "navigation" :files ("swiper.el"))
  :bind ("C-f" . swiper)
  :config
  (ivy-mode 1)
  (define-key ivy-minibuffer-map (kbd "C-f") 'ivy-previous-history-element)
  (define-key ivy-minibuffer-map (kbd "<next>") 'ivy-scroll-up-command)
  (define-key ivy-minibuffer-map (kbd "<prior>") 'ivy-scroll-down-command)
  (define-key ivy-minibuffer-map (kbd "<escape>") 'minibuffer-keyboard-quit)
  ;; (define-key ivy-minibuffer-map (kbd "C-g") 'minibuffer-keyboard-quit)

  (ivy-set-actions
   'counsel-find-file
   '(("j" find-file-other-window "other window")
	 ("b" (lambda (_) (interactive) (counsel-bookmark)) "bookmark")))
  )

(use-package yasnippet
  :straight t
  :defer 5
  :diminish yas-minor-mode
  :config (yas-global-mode 1))

(use-package hi-lock
  :defer t
  :diminish (hi-lock-mode . ""))

(use-package expand-region
  :straight t
  :defer t)

(use-package undo-tree
  :diminish
  :straight t
  :bind (("C-z" . undo-tree-undo)
		 ("C-y" . undo-tree-redo))
  :config

  ;; Disable undo-in-region. It sounds like a cool feature, but
  ;; unfortunately the implementation is very buggy and usually causes
  ;; you to lose your undo history if you use it by accident.
  (setq undo-tree-enable-undo-in-region nil)

  :init
  (progn
	(global-undo-tree-mode)
	;;http://www.star.bris.ac.uk/bjm/bjm-starter-init.el
	(defalias 'redo 'undo-tree-redo)
	(defalias 'undo 'undo-tree-undo)
	(define-key undo-tree-map (kbd "C-_") nil)
	))

(use-package web-mode
  :straight t)

(use-package tramp
  :defer t
  :init
  (when (string-equal system-type "windows-nt")
	(setq tramp-default-method "plink")))
;;(find-file "/plink:cbean@192.168.100.145|sudo:localhost:/etc/nginx/sites-enabled/default")
;;(find-file "/plink:cbean@192.168.100.145|sudo:localhost:/etc/riemann/riemann.config")
;;(find-file "/plink:cbean@192.168.100.145:/opt/")
;;(find-file "/plink:cbean@192.168.100.144:/ciee/")
;;(find-file "/plink:cbean@192.168.100.144|sudo:localhost:/ciee/www/test_api/api.py")
;;(find-file "/plink:cbean@192.168.100.146:/opt")
;;(find-file "/plink:cbean@monitor.ciee.org|sudo:localhost:/etc/curator/curator.yml")

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
			 ;;("w" . count-words-region)
			 ;;("m" . apply-macro-to-region-lines)
			 ("k" . comment-region)
			 ("u" . uncomment-region)
			 ;;:map selected-org-mode-map
			 ;;("t" . org-table-convert-region))
			 )
  (global-selected-minor-mode t))

;;;https://github.com/justbur/emacs-which-key
(use-package which-key
  :straight t
  :diminish
  :config (which-key-mode))

(use-package clojure-mode
  ;; :bind (:map clojure-mode-map
  ;;   ("<kp-add>" . origami-open-node-recursively)
  ;;   ("C-<kp-add>" . origami-open-all-nodes)
  ;;   ("C-<kp-subtract>" . origami-close-all-nodes)
  ;;   ("<kp-subtract>" . origami-close-node))
  :config
  (add-hook 'clojure-mode-hook
			(lambda ()
			  (origami-mode 1)))
  :straight t)

(use-package hydra
  :straight t)

(use-package company
  :straight t
  :diminish
  :config (global-company-mode)
  (bind-keys :map company-active-map
			 ("C-s" . save-buffer)
			 ("C-f" . company-search-candidates)))

(use-package multiple-cursors
  :bind (("C-d" . mc/mark-next-word-like-this)
		 ("C-S-L" . mc/edit-beginnings-of-lines))
  :straight t)

(use-package csharp-mode
  :straight t
  :config
  (add-hook 'csharp-mode-hook
			(lambda ()
			  (hs-minor-mode 1)
			  (setq indent-tabs-mode nil)
			  )))

(use-package powershell
  :straight t
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
			  ("M-." . dumb-jump-go)
			  ("M-," . dumb-jump-back)
			  ))

(use-package avy
  :straight t
  :bind (("M-c" . avy-goto-word-1)
		 ("M-C" . avy-goto-word-1-above))
  :defer t)

(use-package ace-window
  :straight t
  :bind (("M-O" . ace-window)
		 ("M-o" . ace-window))
  :defer t)

;;https://github.com/abo-abo/swiper/issues/881
;;put most recent commands at the top
(use-package smex
  :straight t
  ;; :config
  ;; ;;stolen from emacs-starter-kit
  ;; (setq smex-save-file (concat user-emacs-directory ".smex-items"))
  ;; (smex-initialize)
  ;; (global-set-key (kbd "M-a") 'smex)
  )

(use-package dumb-jump
  :straight t
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
  ;; "Push a mark on the stack before jumping"
  ;; (push-mark))

  (setq dumb-jump-force-searcher 'rg)
  ;;(setq dumb-jump-debug t)

  ;;(print dumb-jump-language-file-exts)
  ;;(print dumb-jump-find-rules)
  )

(use-package org
  ;;:straight t
  :defer t
  :init
  ;;https://emacs.stackexchange.com/questions/26287/move-to-the-beginning-of-a-heading-smartly-in-org-mode/26340
  (setq org-special-ctrl-a/e t)
  :bind (:map org-mode-map
			  ("<f12>" . org-clock-in)
			  ("C-y" . undo-tree-redo)
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

  (setq org-src-fontify-natively t)

  ;;bullets-mode requires org-mode to be already loaded and the use-package :config doesn't seem to turn it on
  (add-hook 'org-mode-hook
			(lambda ()
			  ;;(which-function-mode 0);;turn off current function in status bar
			  (org-bullets-mode 1)))
  )

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

  (add-to-list 'hs-special-modes-alist
			   '(csharp-mode "{" "}" "/[*/]" nil nil))

  (add-hook 'csharp-mode-hook (lambda()
								(setq-local hs-hide-all-non-comment-function 'ttn-hs-hide-level-2))))

(use-package ag
  :straight t)

(use-package deadgrep
  :straight t)

(use-package delight
  :straight t)

(use-package projectile
  ;;:delight '(:eval (concat " " (projectile-project-name)))
  :straight t
  :config (setq projectile-completion-system 'ivy)
  (projectile-global-mode))

(use-package magit
  :straight t
  :defer t)

(use-package js2-mode
  :straight t)

(use-package yaml-mode
  :straight t)

(use-package markdown-mode
  :straight t)

(use-package beacon
  :straight t)

(use-package golden-ratio
  :diminish
  :config
  (define-advice select-window (:after (window &optional no-record) golden-ratio-resize-window)
	(golden-ratio)
	nil)
  :straight t)

(use-package goto-chg
  :bind (("C--" . goto-last-change)
		 ("C-_" . goto-last-change-reverse))
  :straight t)

(use-package git-timemachine
  :straight t)

(use-package dockerfile-mode
  :straight t)

(use-package go-mode
  :straight t
  :bind (:map go-mode-map
			  ("<f12>" . dumb-jump-go)
			  ("M-." . dumb-jump-go)
			  ("M-," . dumb-jump-back)))

;; (use-package key-chord
;;   :straight t
;;   :config
;;   (key-chord-define-global "fg" 'avy-goto-char))

(use-package origami
  :straight t
  :config
  (add-to-list 'origami-parser-alist '(powershell-mode . origami-c-style-parser)))

(when (file-exists-p "~/src/ledger/lisp/ledger-mode.el")  
  (add-to-list 'load-path "~/src/ledger/lisp")

  (use-package ledger-mode
    :init
     (setq ledger-reports
           (quote
            (("bal" "eledger bal")
             ("reg" "eledger reg")
             ("payee" "eledger reg @%(payee) and not expenses and not income")
             ("account" "eledger reg %(account)"))))
     
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

    (defun ledger-remove-check-number ()
      (interactive)
      (let* ((beg (line-beginning-position))
             (end (line-end-position)))
        (save-excursion
          (narrow-to-region beg end)
          (replace-regexp "(.*)" "()")
          (whitespace-cleanup)
          (widen)
          (ledger-narrow-to-account))))

    ;; (defun current-line-empty-p ()
    ;;   (save-excursion
    ;;  (beginning-of-line)
    ;;  (looking-at "[[:space:]]*$")))

    (defun current-line-spaces-p ()
      (save-excursion
        (beginning-of-line)
        (looking-at "[[:space:]]*$")))
    
    (setq ledger-binary-path "/home/cbean/.emacs.d/bin/ledger-sorted")

    ;;remove cleared * if there is one when copying a transaction
    (defadvice ledger-copy-transaction-at-point (after say-ouch activate)
      ;;(print "AAAAAAAAAAAAAAAAAAAAAAA")
      (ledger-navigate-beginning-of-xact)
      (if (string= "cleared" (ledger-transaction-state))
          (ledger-toggle-current))
      (ledger-navigate-beginning-of-xact)
      (ledger-remove-check-number)
      (ledger-navigate-end-of-xact)
      (if (current-line-spaces-p)
          (kill-whole-line))
      (insert "\n")
      ;;(previous-line)
      (forward-line -1)
      (ledger-navigate-beginning-of-xact)
      (recenter))
    
    ;;override because ledger-xact-payee always returns nil and regexp-quote can't handle it
    (defun ledger-report-payee-format-specifier ()
      ;;(ledger-read-string-with-default "Payee" (regexp-quote (ledger-xact-payee))))
      (ledger-read-string-with-default "Payee"  (ledger-xact-payee)))

    (defun ledger-narrow-to-account ()
      (interactive)
      (let ((i 0) (j 0))
        (search-forward ";----")
        (beginning-of-line)
        (setq i (point))
        
        (search-backward ";----")
        (beginning-of-line)
        (setq j (point))
        
        (narrow-to-region i j)
        (end-of-buffer)))))

;;Mac specific stuff
(when (string-equal system-type "darwin")
  (bind-key* "<end>" 'end-of-line)  ; make end do what it's supposed to do
  (setq mac-command-modifier 'meta) ; make cmd do Meta
  (setenv "PATH" (concat (getenv "PATH") ":/opt/local/bin"))) ;; allow emacs to find ag installed by macports

(use-package diminish
  :init
  (diminish 'yas-minor-mode)
  (diminish 'ivy-mode)
  (diminish 'selected-minor-mode)
  (diminish 'company-mode)
  (diminish 'undo-tree-mode)
  (diminish 'which-key-mode)
  :straight t)

(require 'ansi-color)
(defun display-ansi-colors ()
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

(use-package htmlize
  :straight t)

(use-package nginx-mode
  :straight t)

(use-package php-mode
  :straight t)


(bind-key "M-;" 'comment-or-uncomment-region-or-line)

(bind-key "M-2" 'delete-window)
(bind-key "M-3" 'delete-other-windows)

;; (bind-key "M-$" 'split-window-horizontally)
;; (bind-key "M-4" 'split-window-vertically)

(bind-key "C-s" 'save-buffer)

;;http://stackoverflow.com/questions/7411920/how-to-bind-search-and-search-repeat-to-c-f-in-emacs
;;(bind-key (kbd "C-f" 'isearch-repeat-forward)
(bind-key "C-o" 'counsel-find-file)
;;(bind-key "C-x C-r" 'recentf-open-files)

(bind-key* "C-a" 'mark-whole-buffer)
(bind-key "M-SPC" 'set-mark-command)

(bind-key "C-<next>" 'ergoemacs-next-user-buffer)
(bind-key "C-<prior>" 'ergoemacs-previous-user-buffer)

;; (bind-key "M-G" 'ergoemacs-kill-line-backward)
;; (bind-key "M-g" 'kill-line)
;; (bind-key "C-S-L" 'kill-whole-line)
;; (bind-key "C-l" 'goto-line)
(bind-key "M-j" 'join-line)
(bind-key "C-S-k" 'ergoemacs-kill-line-backward)
;; (bind-key "C-k" 'kill-line)

(bind-key "C-w" 'kill-this-buffer)
(bind-key "C-n" 'ergoemacs-new-empty-buffer)

(bind-key "M-\\" 'hippie-expand)
(bind-key "C-\\" 'hippie-expand)

(bind-key "<home>" 'cb-smart-beginning-of-line)
(bind-key "C-%"    'cb-goto-match-paren)
(bind-key "C-c d"  'cb-duplicate-current-line-or-region)

(bind-key "C-c w" 'hydra-window/body)

(bind-key "C-@" 'er/expand-region)

(bind-key* "M-a" 'counsel-M-x)

;;(bind-key* "C-l" 'goto-line)

(bind-key "M-b" 'ivy-switch-buffer)

(bind-key "M-z" 'zap-up-to-char)
(bind-key "M-Z" 'backwards-zap-to-char)

;;https://stackoverflow.com/questions/29816326/how-to-show-path-to-file-in-the-emacs-mode-line
(setq frame-title-format
	  '(buffer-file-name "%b - %f" ; File buffer
		 (dired-directory dired-directory ; Dired buffer
		   (revert-buffer-function "%b" ; Buffer Menu
			 ("%b - Dir: " default-directory))))) ; Plain buffer

(server-start)
