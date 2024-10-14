;;; LSP config

(straight-use-package 'org)
;; (use-package org)
(require 'org-tempo)  ;开启easy template，`< s TAB` creates a code block
(use-package org-contrib)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "STARTED(s)" "|" "DONE(d!/!)")
              (sequence "WAITING(w@/!)" "SOMEDAY(S)" "|" "CANCELLED(c@/!)" "MEETING(m)"))))

(use-package org-roam
    :custom
        (org-roam-dailies-directory "daily/") ;; 默认日记目录，上一目录的相对路径
        (org-roam-db-gc-threshold most-positive-fixnum) ;; 提高性能
        ;; (setq org-roam-completion-everywhere t) ; 链接补全？
    :bind
        (("C-c n i" . org-roam-node-insert)     ;; 插入一条笔记的链接
        ("C-c n f" . org-roam-node-find)        ;; 通过关键词查找笔记并跳转
        ("C-c n g" . org-roam-graph)
        ("C-c n o" . org-id-get-create)
        ("C-c n t" . org-roam-tag-add)    ; 添加tag
        ("C-c n a" . org-roam-alias-add)        ; 添加别名
        ("C-c n c" . org-roam-capture)         ;; 创建一条新笔记，快速退出
        ("C-c n l" . org-roam-buffer-toggle)   ;; 显示后链窗口
        ("C-c n u" . org-roam-ui-mode)         ;; 浏览器中可视化
     ;; ("C-c n j" . org-roam-daily-capture-today))        
        :map org-mode-map
            ("C-c n d" . org-roam-dailies-map) ;; 日记菜单
            ("C-M-i" . completion-at-point))
     :after org
     :hook 
     (org-mode . (lambda () (setq truncate-lines nil)))   ; 自动折行
    :config
        (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
        (require 'org-roam-dailies)  ;; 启用日记功能
        (org-roam-db-autosync-mode)) ;; 启动时自动同步数据库


(use-package org-roam-ui
:after org-roam
:custom
(org-roam-ui-sync-theme t) ;; 同步 Emacs 主题
(org-roam-ui-follow t) ;; 笔记节点跟随
(org-roam-ui-update-on-save t))

(use-package org-download
    :defer t
    :after org
    :bind
    (:map org-mode-map
        ("C-M-y" . org-download-clipboard)) ;; 绑定从剪贴版粘贴截图的快捷键
    :config
        (setq org-download-method 'attach)
        ;; (setq-default org-download-heading-lvl nil)
        ;; (setq-default org-download-image-dir "./images")
        ;; (setq org-download-backend "wget")
        ;; (setq org-download-abbreviate-filename-function (lambda (fn) fn)) ; use original filename
        ;; (defun dummy-org-download-annotate-function (link)
        ;; "")
        ;; (setq org-download-annotate-function
        ;;   #'dummy-org-download-annotate-function)
                 :hook
                 (dired-mode . org-download-enable)

                 )

;; Drag-and-drop to `dired`

(use-package org-superstar
    :hook
    (org-mode . (lambda () (org-superstar-mode 1))))

(provide 'orgsetting)
;;; orgsetting.el ends here
