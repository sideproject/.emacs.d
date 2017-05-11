;;http://emacs.stackexchange.com/questions/9528/is-it-possible-to-remove-emsp-from-clock-report-but-preserve-indentation
(defun cb-org-clocktable-indent-string (level)
  (if (= level 1)
      ""
    (let ((str "\\"))
      (while (> level 2)
        (setq level (1- level)
              str (concat str "__")))
      (concat str "__ "))))

(defun cb-goto-current-day ()
  "Go to the top org level for this day."
  (interactive)
  (beginning-of-line)
  (while (not (looking-at "* "))
    (org-up-element)
    (beginning-of-line)))

(defun cb-org-clock-report ()
  (interactive)
  (cb-goto-current-day)
  (next-line)
  (beginning-of-line)
  (if (looking-at "#\\+BEGIN: clocktable")
      (progn
		(message "Updating Report")
		(org-clock-report))
    (progn
      (previous-line)
      (message "Creating new Report")
      (org-clock-report))))

(defun cb-org-estimate-report ()
  (interactive)
  (cb-goto-current-day)
  (next-line)
  (beginning-of-line)
  (if (looking-at "#\\+BEGIN: columnview")
      (progn
		(message "Updating Report")
		(org-ctrl-c-ctrl-c))
    (progn
      (previous-line)
      (message "Creating new Report")
      (org-insert-columns-dblock))))


;;;http://www.emacswiki.org/emacs/ElispCookbook#toc4
(defun string/starts-with (string prefix)
  "Return t if STRING starts with prefix."
  (and (string-match (rx-to-string `(: bos ,prefix) t)
					 string)
       t))

(defun cb-goto-previous-heading ()
  (interactive)
  (beginning-of-line)
  
  (let ((asdfe (buffer-substring (point) (+ (point) 3))))
    
    (when (string= asdfe "** ")
      (org-backward-element))
    
    (when (string= asdfe "***")
      (org-up-element))

    (when (not (string/starts-with asdfe "*"))
      (org-up-element)
      (cb-goto-previous-heading))))

(defun cb-goto-next-heading ()
  (interactive)
  (beginning-of-line)
  
  (let ((asdfe (buffer-substring (point) (+ (point) 3))))

    (when (string= asdfe "** ")
      (org-forward-element))
    
    (when (string= asdfe "***")
      (org-up-element)
      (org-forward-element))

    (when (not (string/starts-with asdfe "*"))
      (org-up-element)
      (cb-goto-next-heading))))

(use-package org-bullets)

(use-package hydra)

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
  ("q" nil)
  )

(use-package org
  :ensure t
  :defer t
  :config
  (require 'yasnippet)
  (defun yas/org-very-safe-expand ()
    (let ((yas/fallback-behavior 'return-nil)) (yas/expand)))
  
  ;;make yasnippets tab completion work
  (make-variable-buffer-local 'yas/trigger-key)
  (setq yas/trigger-key [tab])
  (add-to-list 'org-tab-first-hook 'yas/org-very-safe-expand)
  (define-key yas/keymap [tab] 'yas/next-field)
  
  (bind-key "<f12>" 'org-clock-in org-mode-map)
  (bind-key "C-c C-x C-r" 'cb-org-clock-report org-mode-map)

  ;;(define-key org-mode-map [(control y)] nil) ;; redo
  ;;(define-key org-mode-map [(meta a)] nil) ;;smex

  ;; (define-key org-mode-map [(control up)] 'outline-previous-heading)
  ;; (define-key org-mode-map [(control down)] 'outline-next-heading)
  (define-key org-mode-map [(control up)] 'cb-goto-previous-heading)
  (define-key org-mode-map [(control down)] 'cb-goto-next-heading)

  (define-key org-mode-map (kbd "<f5>") 'hydra-x/body)

  (setq org-agenda-start-with-log-mode t) ;; turn on logging mode at startup

  (setq org-clock-clocktable-default-properties '(:maxlevel 3 :tags "-NOBILL"))
  (setq org-src-fontify-natively t)
  ;;(require 'ob-powershell)

  (advice-add 'org-clocktable-indent-string :override #'cb-org-clocktable-indent-string)
  
  ;;https://lists.gnu.org/archive/html/emacs-orgmode/2010-04/msg00457.html
  (defun cb-org-clock-get-running-clock-minutes ()
	(- (org-clock-get-clocked-time) org-clock-total-time)
	;;(format "org: %d/%d min" 
	;;	(- (org-clock-get-clocked-time) org-clock-total-time) (org-clock-get-clocked-time))
	)

  (defun cb-org-mode-filter-tags ()
	(setq x (assoc "ALLTAGS" (org-entry-properties)))
	(unless (string= (cdr x) ":NOBILL:")
	  t))

  (defun cb-org-clock-sum-today (&optional headline-filter)
	"Sum the times for each subtree for today."
	(let ((range (org-clock-special-range 'today)))
	  (org-clock-sum (car range) (cadr range)
					 headline-filter :org-clock-minutes-today)))

  ;;http://emacs.stackexchange.com/questions/1035/how-can-i-see-total-time-today-on-all-projects-in-the-modeline
  (defun saintaardvark-org-clock-todays-total ()
	"Display total minutes clocked into org-mode for today."
	(interactive)
	(if (and
		 (boundp 'org-clock-total-time)
		 (boundp 'org-clock-current-task)
		 (fboundp 'org-clock-get-clocked-time))
		(save-excursion
		  (set-buffer "time-tracking.org")
		  (let ((work-minutes (+ (cb-org-clock-get-running-clock-minutes) (cb-org-clock-sum-today 'cb-org-mode-filter-tags))))
			(format " {%s - %s} " (org-minutes-to-clocksum-string work-minutes) (org-minutes-to-clocksum-string (- 450 work-minutes)))))))

  ;; ;;http://emacs.stackexchange.com/questions/13855/how-to-append-string-that-gets-updated-to-mode-line
  ;; ;;http://www.emacswiki.org/emacs/gnus-notify.el
  ;; ;;add to mode line
  ;; (unless (member '(:eval (saintaardvark-org-clock-todays-total)) global-mode-string)
  ;;   (setq global-mode-string
  ;; 	    (append global-mode-string
  ;; 		    (list '(:eval (saintaardvark-org-clock-todays-total))))))

  )

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

(provide 'org-customizations)
