;; Main use is to have my key bindings have the highest priority
;; https://github.com/kaushalmodi/.emacs.d/blob/master/elisp/modi-mode.el

(defvar my-mode-map (make-sparse-keymap)
  "Keymap for `my-mode'.")

;;;###autoload
(define-minor-mode my-mode
  "A minor mode so that my key settings override annoying major modes."
  ;; If init-value is not set to t, this mode does not get enabled in
  ;; `fundamental-mode' buffers even after doing \"(global-my-mode 1)\".
  ;; More info: http://emacs.stackexchange.com/q/16693/115
  :init-value t
  :lighter " my-mode"
  :keymap my-mode-map)

;;;###autoload
(define-globalized-minor-mode global-my-mode my-mode my-mode)

;; https://github.com/jwiegley/use-package/blob/master/bind-key.el
;; The keymaps in `emulation-mode-map-alists' take precedence over
;; `minor-mode-map-alist'
;;(add-to-list 'emulation-mode-map-alists `((my-mode . ,my-mode-map)))
;;(print emulation-mode-map-alists)
;; (print (car (cdr (cdr (cdr emulation-mode-map-alists)))))

;; ensure that we stay BELOW the cua--keymap-alist or our C-c bindings above will knock out CUA mode
;;(require 'dash)
;;(setq emulation-mode-map-alists (-insert-at 2 `(my-mode . ,my-mode-map) emulation-mode-map-alists))
;; (-insert-at 1 'x emulation-mode-map-alists) ;; => '(a x b c)

;; ;; Turn off the minor mode in the minibuffer
;; (defun turn-off-my-mode ()
;;   "Turn off my-mode."
;;   (my-mode -1)
;;   )

;; (add-hook 'minibuffer-setup-hook #'turn-off-my-mode)

(provide 'my-mode)

;; Minor mode tutorial: http://nullprogram.com/blog/2013/02/06/
