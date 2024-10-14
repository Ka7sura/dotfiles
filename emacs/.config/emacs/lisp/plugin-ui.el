;;; ui初始化

;;; dashboard
(use-package dashboard
    :config
    (dashboard-setup-startup-hook))

;;; 提示信息
;; 内置 Emacs 帮助的替代方案，提供了更多上下文信息
(use-package helpful
  :config
    (global-set-key (kbd "C-h f") #'helpful-callable)
    (global-set-key (kbd "C-h v") #'helpful-variable)
    (global-set-key (kbd "C-h k") #'helpful-key)
    (global-set-key (kbd "C-h x") #'helpful-command)
    ;; ivy helpful
    (when (fboundp 'counsel-describe-function-function)(setq counsel-describe-function-function #'helpful-callable))
    (when (fboundp 'counsel-describe-variable-function)(setq counsel-describe-variable-function #'helpful-variable)))
;; 快捷键的提示
(use-package which-key
    :hook (after-init . which-key-mode))

;;; modeline/状态栏
;; doom modeline
(use-package doom-modeline
  :init
  (doom-modeline-mode t))

;;; minibuffer
;; 垂直补全ui
(use-package vertico        
    :init
        (vertico-mode t))
;; 后端-模糊搜索
(use-package orderless      
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))
;; 显示更多信息
(use-package marginalia     
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init (marginalia-mode))
;; 当前函数的快捷键等操作
(use-package embark         
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
    ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))


(provide 'plugin-ui)
;;; plugin-ui.el ends here
