;;; init.el -*- lexical-binding: t -*-

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory)) ; 设定源码加载路径

;; 内置的基本设置
(require 'init-os)      ; 1. 包括操作系统的变量和文件地址
(require 'init-qstart)
(require 'init-ui)
(require 'init-option)
(require 'init-pm)
(require 'init-keymap)

;; 插件设置
(require 'plugin-ui)
(require 'plugin-lsp)
(require 'plugin-dap)
(require 'plugin-code)

;; 其他的主要设置
(require 'orgsetting)
(require 'other)


;; 基本设置
;; (setq-default
;;     indicate-buffer-boundaries 'left ;; 在窗口边缘上显示一个小箭头指示当前 buffer 的边界
;;     delete-by-moving-to-trash t                      ;; 删除文件移动到垃圾箱
;;     window-combination-resize t                      ;; 新窗口平均其他左右窗口
;;     x-stretch-cursor t                               ;; 将光标拉伸到字形宽度
;;     kill-whole-line t)  ;; C-k时,同时删除该行

;; Set default font face
;; (set-face-attribute 'default nil :font "JetBrainsMono")


;; Miscellaneous options
;; (setq-default major-mode
;;     (lambda () ; guess major mode from file name
;;         (unless buffer-file-name
;;         (let ((buffer-file-name (buffer-name)))
;;         (set-auto-mode)))))

;; (setq window-resize-pixelwise t)
;; (setq frame-resize-pixelwise t)
;; (save-place-mode t)
;; (savehist-mode t)
;; (recentf-mode t)
;; (defalias 'yes-or-no #'y-or-n-p)




(setq custom-file (locate-user-emacs-file "custom.el")) ; 存放使用编辑器接口产生的配置信息
(when (file-exists-p custom-file)
  (load custom-file))           ; 加载 Emacs 自动设置的变量


;;; init.el ends here
