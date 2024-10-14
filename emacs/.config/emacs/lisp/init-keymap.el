;; Keymap

(global-set-key (kbd "RET") 'newline-and-indent)    ; 回车后自动缩进

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (evil-mode 1)
  ;; https://emacs.stackexchange.com/questions/46371/how-can-i-get-ret-to-follow-org-mode-links-when-using-evil-mode
  (with-eval-after-load 'evil-maps
    (define-key evil-motion-state-map (kbd "RET") nil))
  )


(provide 'init-keymap)
;;; init-keymap.el ends here
