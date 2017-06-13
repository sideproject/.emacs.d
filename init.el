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
 '(package-selected-packages
   (quote
	(xah-fly-keys web-mode csharp-mode rust-mode dumb-jump ag omnisharp smex expand-region magit projectile company hydra yasnippet neotree ace-window avy ace-jump-mode powershell multiple-cursors t: back-button clojure-mode auto-complete counsel try which-key use-package undo-tree)))
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

;;(set-face-attribute 'region nil :background "#666")
;;(set-face-attribute 'show-paren-match nil :background "gray21")

;;turn off the tool bar
(tool-bar-mode -1)

;;use spaces instead of tabs
;;(setq-default indent-tabs-mode nil)

;;use spaces instead of tabs just for powershell-mode
(add-hook 'powershell-mode-hook (lambda ()
								  (setq indent-tabs-mode nil)
								  (hs-minor-mode 1)))

(setq show-paren-style 'expression)

;;Show matching paren
(show-paren-mode 1)

(add-to-list 'load-path "~/.emacs.d/lisp/")

;;macports puts cert.pem in /opt/local
(when (string-equal system-type "darwin")
  (require 'gnutls)
  (add-to-list 'gnutls-trustfiles "/opt/local/etc/openssl/cert.pem"))

(require 'package)
;;https://emacs.stackexchange.com/questions/2969/is-it-possible-to-use-both-melpa-and-melpa-stable-at-the-same-time

;;http://stackoverflow.com/questions/1664202/emacs-lisp-evaluate-variable-in-alist
;;use MELPA on windows to get latest but stay on MELPA-STABLE on arch-linux since latest omnisharp requires dotnet which i can't get to work yet.
;; (let ((melpa-priority
;; 	   (cond ((string-equal system-type "windows-nt") 100)
;; 			 (t 0))))
  
;;   (setq package-archives
;; 		'(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
;; 		  ("MELPA Stable" . "https://stable.melpa.org/packages/")
;; 		  ("MELPA"        . "https://melpa.org/packages/"))
;; 		package-archive-priorities
;; 		'(("MELPA Stable" . 10)
;; 		  ("GNU ELPA"     . 5)
;; 		  `("MELPA"       . ,melpa-priority))))

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
  ;;(setq ispell-personal-dictionary "C:/path/to/your/.ispell") 
  (setq ispell-program-name "aspell"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;;Turn on column number
(column-number-mode 1)

;; Lets user type y and n instead of the full yes and no.
(defalias 'yes-or-no-p 'y-or-n-p)

;; for Windows and Mac, set Middle-click to do nothing (it can be customizable by the user)
(when (or (string-equal system-type "windows-nt")
          (string-equal system-type "darwin"))
  (global-set-key [mouse-2] nil))

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

;;no backup or autosave
(setq backup-by-copying t
      make-backup-files nil
      auto-save-default nil)

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
  ;;:config
  ;;(global-undo-tree-mode))
  :init
  (progn	
    (global-undo-tree-mode)
	;;http://www.star.bris.ac.uk/bjm/bjm-starter-init.el
    (defalias 'redo 'undo-tree-redo)
    (defalias 'undo 'undo-tree-undo)
    ))

(use-package web-mode
  :ensure t)

;; (use-package text
;;   :defer t
;;   :config
;;   ;;http://stackoverflow.com/a/11624677
;;   (defun my-indent-region (N)
;;     (interactive "p")
;;     (if mark-active
;; 		(progn (indent-rigidly (min (mark) (point)) (max (mark) (point)) (* N 4))
;; 			   (setq deactivate-mark nil))
;;       (dotimes (i (* N 4))
;; 		(insert " "))))

;;   (defun my-unindent-region (N)
;;     (interactive "p")
;;     (if mark-active
;; 		(progn (indent-rigidly (min (mark) (point)) (max (mark) (point)) (* N -4))
;; 			   (setq deactivate-mark nil))
;;       (indent-rigidly (line-beginning-position) (line-end-position) (* N -4))))

;;   (bind-keys :map text-mode-map
;; 			 ("<tab>" . my-indent-region)
;; 			 ("<backtab>" . my-unindent-region)))


;;(byte-compile-file "C:/Users/cbean/Desktop/emacs-24.5-bin-i686-mingw32/share/emacs/24.5/lisp/net/tramp-sh.el")
(use-package tramp
  :defer t
  :init
  (when (string-equal system-type "windows-nt")
	(setq tramp-default-method "plink")))

(use-package selected
										;:defer t 
										;:commands selected-minor-mode
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
  :ensure t)

(use-package hydra
  :ensure t)

(use-package company
  :ensure t
  :defer t
  :diminish company-mode
  :config (global-company-mode))

(use-package back-button
  :ensure t
  :diminish back-button-mode
  :config
  (back-button-mode 1))

(use-package multiple-cursors
  :ensure t)

;; (use-package omnisharp
;;   :ensure t
;;   :config

;;   (setq omnisharp-debug t)

;;   ;;use older with linux (arch) uses MONO -- unable to get dotnet working on arch yet.
;;   (when (string-equal system-type "gnu/linux")
;; 	(setq omnisharp--curl-executable-path "/usr/bin/curl")
;; 	(setq omnisharp-server-executable-path "/home/cbean/src/omnisharp-server/OmniSharp/bin/Debug/OmniSharp.exe"))

;;   ;;use latest MELPA with windows -- uses dotnet
;;   (when (string-equal system-type "windows-nt")
;; 	(setq omnisharp--curl-executable-path "U:/bin/gnu/curl.EXE")
;; 	(setq omnisharp-server-executable-path "C:/Users/cbean/Desktop/omnisharp-win-x64-netcoreapp1.1/OmniSharp.exe")
;; 	(require 'omnisharp-utils)
;; 	(require 'omnisharp-server-management)
;; 	(require 'shut-up)))

(add-to-list 'auto-mode-alist '("\\.psm1\\'" . powershell-mode))
(add-to-list 'auto-mode-alist '("\\.psd1\\'" . powershell-mode))  
(use-package powershell
  :ensure t
  :config
  :bind (("<f12>" . dumb-jump-go)))
		 ;;("C-z" . undo-tree-undo)
		 ;;("C-y" . undo-tree-redo)))

(use-package ace-jump-mode
  :ensure t
  :defer t)

(use-package avy
  :ensure t
  :defer t)

(use-package ace-window
  :ensure t
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
			   
  (defadvice dumb-jump-go (before my-dumb-jump-go-advice (&optional opts) activate)
	"Push a mark on the stack before jumping"
	(push-mark))

  (setq dumb-jump-force-searcher 'rg)
  ;;(setq dumb-jump-debug t)
  
  ;;(print dumb-jump-language-file-exts)
  ;;(print dumb-jump-find-rules)
  )

(use-package neotree
  :ensure t
  :defer t)

;;(load "~/.emacs.d/lisp/org-customizations")
(use-package org-customizations)

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

;;http://irreal.org/blog/?p=3341
;; (setq diredp-hide-details-initially-flag nil)
;; (use-package dired+
;;   :ensure t
;;   :init
;;   (diredp-toggle-find-file-reuse-dir t)
;;   )

(use-package hideshow
  :config
  ;;https://coderwall.com/p/u-l0ra/ruby-code-folding-in-emacs
  (add-to-list 'hs-special-modes-alist
			   `(ruby-mode
				 ,(rx (or "def" "class" "module" "do" "{" "[")) ; Block start
				 ,(rx (or "}" "]" "end"))                       ; Block end
				 ,(rx (or "#" "=begin"))                        ; Comment start
				 ruby-forward-sexp nil))

  (add-to-list 'hs-special-modes-alist
 			 '(powershell-mode "{" "}" "#" nil nil))

  (global-set-key (kbd "<kp-add>") 'hs-show-block)
  (global-set-key (kbd "C-<kp-add>") 'hs-show-all)
  (global-set-key (kbd "C-<kp-subtract>") 'hs-hide-all)
  (global-set-key (kbd "<kp-subtract>") 'hs-hide-block))

(use-package ag
  :ensure t)

(use-package projectile
  :ensure t
  :config (setq projectile-completion-system 'ivy)
  (projectile-global-mode))

(when (not (string-equal system-type "windows-nt"))
  (use-package magit
	:ensure t
	:defer t))


;;Mac specific stuff
(when (string-equal system-type "darwin")
  (bind-key* "<end>" 'end-of-line)  ; make end do what it's supposed to do
  (setq mac-command-modifier 'meta) ; make cmd do Meta
  (setenv "PATH" (concat (getenv "PATH") ":/opt/local/bin")) ;; allow emacs to find ag installed by macports
  )

;; (add-to-list 'load-path "~/.emacs.d/lisp/")
;; (require 'xah-fly-keys)
;; (xah-fly-keys-set-layout "qwerty") ; required if you use qwerty
;; ;; (xah-fly-keys-set-layout "dvorak")
;; (xah-fly-keys 1)



;; (setq w32-pass-rwindow-to-system nil)
;; (setq w32-rwindow-modifier 'super) ; Right Windows key

;; (defun xah-fly--define-keys (*keymap-name *key-cmd-alist)
;;   "Map `define-key' over a alist *key-cmd-alist.
;; Example usage:
;; ;; (xah-fly--define-keys
;; ;;  (define-prefix-command 'xah-fly-dot-keymap)
;; ;;  '(
;; ;;    (\"h\" . highlight-symbol-at-point)
;; ;;    (\".\" . isearch-forward-symbol-at-point)
;; ;;    (\"1\" . hi-lock-find-patterns)
;; ;;    (\"w\" . isearch-forward-word)))
;; Version 2017-01-21"
;;   (interactive)
;;   (mapc
;;    (lambda (-pair)
;;      (define-key *keymap-name (xah-fly--key-char (kbd (car -pair))) (cdr -pair)))
;;    *key-cmd-alist))

;; (defun xah-search-current-word ()
;;   "Call `isearch' on current word or text selection.
;; “word” here is A to Z, a to z, and hyphen 「-」 and underline 「_」, independent of syntax table.
;; URL `http://ergoemacs.org/emacs/modernization_isearch.html'
;; Version 2015-04-09"
;;   (interactive)
;;   (let ( -p1 -p2 )
;;     (if (use-region-p)
;;         (progn
;;           (setq -p1 (region-beginning))
;;           (setq -p2 (region-end)))
;;       (save-excursion
;;         (skip-chars-backward "-_A-Za-z0-9")
;;         (setq -p1 (point))
;;         (right-char)
;;         (skip-chars-forward "-_A-Za-z0-9")
;;         (setq -p2 (point))))
;;     (setq mark-active nil)
;;     (when (< -p1 (point))
;;       (goto-char -p1))
;;     (isearch-mode t)
;;     (isearch-yank-string (buffer-substring-no-properties -p1 -p2))))

;; (use-package modalka
;;   :bind
;;   (("M-;" . modalka-global-mode)
;;    ("<kp-0>" . modalka-global-mode)
;;    ("<f8>" . modalka-global-mode)
;;    ;;("<escape>" . modalka-global-mode)
;;    )
;;   :ensure t
;;   :config
;;   ;; (modalka-define-kbd "W" "M-w")
;;   ;; (modalka-define-kbd "Y" "M-y")
;;   ;; (modalka-define-kbd "a" "C-a")
;;   ;; (modalka-define-kbd "b" "C-b")
;;   ;; (modalka-define-kbd "e" "C-e")
;;   ;; (modalka-define-kbd "f" "C-f")
;;   ;; (modalka-define-kbd "g" "C-g")
;;   ;; (modalka-define-kbd "n" "C-n")
;;   ;; (modalka-define-kbd "p" "C-p")
;;   ;; (modalka-define-kbd "w" "C-w")
;;   ;; (modalka-define-kbd "y" "C-y")
;;   ;; (modalka-define-kbd "SPC" "C-SPC")

;;   ;;(define-key modalka-mode-map (kbd "Q") #'my-command)
;;   (define-key modalka-mode-map (kbd "v") #'cua-paste)
;;   (define-key modalka-mode-map (kbd "c") #'cb-copy-and-deselect)

;;   (define-key modalka-mode-map (kbd "d") #'cb-duplicate-current-line-or-region)
;;   (define-key modalka-mode-map (kbd "e") #'eval-last-sexp)
  
;;   (define-key modalka-mode-map (kbd "k") #'comment-line)
;;   (define-key modalka-mode-map (kbd "K") #'uncomment-region)

;;   (define-key modalka-mode-map (kbd "3") #'delete-other-windows)
;;   (define-key modalka-mode-map (kbd "2") #'delete-window)
;;   (define-key modalka-mode-map (kbd ".") #'xah-search-current-word)
;;   (define-key modalka-mode-map (kbd "i") #'modalka-global-mode)

;;   (define-key modalka-mode-map (kbd "h") #'hs-hide-all)
;;   (define-key modalka-mode-map (kbd "H") #'hs-show-all)
;;   (define-key modalka-mode-map (kbd "g") #'keyboard-quit)
;;   (define-key modalka-mode-map (kbd "m") #'mc/mark-next-like-this)
;;   (define-key modalka-mode-map (kbd "a") #'counsel-M-x)
;;   (define-key modalka-mode-map (kbd "@") #'er/expand-region)
;;   (define-key modalka-mode-map (kbd "f") #'swiper)
;;   (define-key modalka-mode-map (kbd "b") #'ibuffer)
;;   (define-key modalka-mode-map (kbd "%") #'cb-goto-match-paren)
;;   (define-key modalka-mode-map (kbd "z") #'zap-up-to-char)
;;   (define-key modalka-mode-map (kbd "Z") #'backwards-zap-to-char)

;;   (defun esc-and-command()
;; 	(interactive)
;; 	(modalka-global-mode 1)
;; 	(minibuffer-keyboard-quit)
;; 	(keyboard-quit)
;; 	)
;;   ;;(define-key modalka-mode-map (kbd "<escape>") #'esc-and-other)
  
;;   (modalka-define-kbd "SPC" "C-SPC")
;;   ;;(bind-key "M-;" 'modalka-global-mode)

;;   (setq-default cursor-type '(bar . 1))
;;   (setq modalka-cursor-type 'box)

;;   (define-key isearch-mode-map (kbd ".") 'isearch-repeat-forward)
;;   (define-key isearch-mode-map (kbd "g") 'keyboard-quit)

;;   (add-to-list 'modalka-excluded-modes 'ibuffer-mode)

;;   ;;https://emacs.stackexchange.com/questions/14755/how-to-remove-bindings-to-the-esc-prefix-key
;;   ;;; esc always quits
;;   ;;(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
;;   ;; (define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
;;   ;; (define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
;;   ;; (define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
;;   ;; (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
;;   ;; (global-set-key [escape] 'keyboard-quit)
;;   (global-set-key [escape] 'esc-and-command)
;;   (bind-key* "C-g" 'esc-and-command)
;;   )



(bind-key "M-2" 'delete-window)
(bind-key "M-3" 'delete-other-windows)

(bind-key "M-$" 'split-window-horizontally)
(bind-key "M-4" 'split-window-vertically)

;;(bind-key "M-i" 'previous-line)
;;(bind-key "M-k" 'next-line)
;;(bind-key "M-j" 'left-char)
;;(bind-key "M-j" 'join-line)
;;(bind-key "M-l" 'right-char)

(bind-key "C-s" 'save-buffer)

;;http://stackoverflow.com/questions/7411920/how-to-bind-search-and-search-repeat-to-c-f-in-emacs
;;(bind-key (kbd "C-f" 'isearch-repeat-forward)
(bind-key "C-o" 'find-file)
;;(bind-key "C-x C-r" 'recentf-open-files)

(bind-key "C-a" 'mark-whole-buffer)
(bind-key "M-SPC" 'set-mark-command)

(bind-key "C-<next>" 'ergoemacs-next-user-buffer)
(bind-key "C-<prior>" 'ergoemacs-previous-user-buffer)

(bind-key "M-G" 'ergoemacs-kill-line-backward)
(bind-key "M-g" 'kill-line)
(bind-key "C-L" 'kill-whole-line)

(bind-key "C-w" 'kill-this-buffer)
(bind-key "C-n" 'ergoemacs-new-empty-buffer)

(bind-key "M-\\" 'hippie-expand)
(bind-key "C-\\" 'hippie-expand)

(bind-key "<home>" 'cb-smart-beginning-of-line)
(bind-key "C-%" 'cb-goto-match-paren)
(bind-key "C-c d" 'cb-duplicate-current-line-or-region)

(bind-key "C-c w" 'hydra-window/body)

(bind-key "C-@" 'er/expand-region)

;;(bind-key "C-f" 'swiper) ;;defined in use-package because we need C-f to do different things in different maps
(bind-key* "M-a" 'counsel-M-x)

;; (bind-key* "C-z" 'undo-tree-undo)
;; (bind-key* "C-y" 'undo-tree-redo)

(bind-key* "C-_" 'back-button-global-forward)
(bind-key* "C--" 'back-button-global-backward)

(bind-key "M-c" 'avy-goto-word-1)
;;(bind-key "M-C" 'avy-goto-word-1-above)
(bind-key "M-O" 'ace-window)
;;(bind-key* "C-l" 'goto-line)

;; (bind-keys :prefix-map vs-prefix-map
;; 		   :prefix "C-k"
;; 		   ("C-c" . comment-region)
;; 		   ("C-u" . uncomment-region))

(bind-key "M-b" 'ibuffer)

(bind-key "M-z" 'zap-up-to-char)
(bind-key "M-Z" 'backwards-zap-to-char)
