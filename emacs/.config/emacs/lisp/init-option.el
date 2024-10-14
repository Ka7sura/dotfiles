;;; option初始化

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(when (fboundp 'show-paren-mode) (show-paren-mode 1))  ; 开启括号匹配
(electric-pair-mode t)                  ; 自动补全括号
(when (fboundp 'delete-selection-mode) (delete-selection-mode 1))  ; 选中后可以直接修改
(setq confirm-kill-emacs #'y-or-n-p)    ; 在关闭 Emacs 前询问是否确认关闭，防止误触
(setq select-enable-primary t)
(global-auto-revert-mode 1) ; 自动加载外部加载过的文件


;;; 历史记录
(when (fboundp 'recentf-mode) (recentf-mode 1))  ; 启用 recentf 模式
(add-hook 'after-init-hook #'save-place-mode); 保存光标位置
(when (fboundp 'savehist-mode) (savehist-mode 1))  ; 启用minibuffer的记录保存
(setq recentf-auto-cleanup 'never)  ; 不要自动清理列表
(setq recentf-max-saved-items 20)  ; 保存最近打开的文件记录数量
(setq enable-recursive-minibuffers t ; Allow commands in minibuffers
              history-length 1000
              savehist-additional-variables '(mark-ring
                                              global-mark-ring
                                              search-ring
                                              regexp-search-ring
                                              extended-command-history)
              savehist-autosave-interval 300)
;;; autobackup
(setq delete-old-versions t)    ; 删除旧备份

;;; autosave
;; (setq auto-save-default nil)     ; 关闭自动保存
(setq auto-save-interval 300)       ; 每300个字符输入后自动保存
(setq auto-save-timeout 120)         ; 如果120秒内没有输入，自动保存

(provide 'init-option)
;;; init-option.el ends here
