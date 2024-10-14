;;; 操作系统判断

  ;; ‘gnu’          compiled for a GNU Hurd system.
  ;; ‘gnu/linux’    compiled for a GNU/Linux system.
  ;; ‘gnu/kfreebsd’ compiled for a GNU system with a FreeBSD kernel.
  ;; ‘darwin’       compiled for Darwin (GNU-Darwin, macOS, ...).
  ;; ‘ms-dos’       compiled as an MS-DOS application.
  ;; ‘windows-nt’   compiled as a native W32 application.
  ;; ‘cygwin’       compiled using the Cygwin library.
  ;; ‘haiku’        compiled for a Haiku system.

(defvar os--win (memq system-type '(ms-dos windows-nt cygwin)) "布尔值，表示该系统是否为Windows（ms-dos windows-nt cygwin）")
(defvar os--mac (eq system-type 'darwin) "布尔值，表示该系统是否为MacOS（Darwin）")
(defvar os--linux (eq system-type 'gnu/linux) "布尔值，表示该系统是否为linux（gnu/linux）")

;; Linux
(when os--linux
(defvar path-cache "~/.tmp/emacs/" "缓存文件位置")
(defvar path-doc "~/Documents/" "org-roam文件位置")
  (setq read-process-output-max (* 1024 1024))) ;; 1mb - dape

;; Windows
(when os--win
    (setq read-process-output-max (* 1024 1024)) ;; 1mb - dape
    (when (fboundp 'scroll-bar-mode) (server-mode 1)))  ;右键emacs打开

;; MaacOS
(when os--mac
  (setq read-process-output-max (* 64 1024))) ;; 64k

;; (use-package emacs 
;;   :if (display-graphic-p) 
;;   :config 
;;   ;; Font settings 
;;   (if *is-windows* 
;;     (progn 
;;       (set-face-attribute 'default nil :font "Microsoft Yahei Mono 9") 
;;       (dolist (charset '(kana han symbol cjk-misc bopomofo)) 
;;         (set-fontset-font (frame-parameter nil 'font) charset (font-spec :family "Microsoft Yahei Mono" :size 12)))) 
;;   (set-face-attribute 'default nil :font "Source Code Pro for Powerline 11")))
;;
;; ;; Mac
;; (when *is-mac* 
;;     (setq mac-command-modifier 'meta)
;;     (setq mac-option-modifier 'none))
;;
;;
;; 文件路径
(setq org-roam-directory (concat path-doc "roam-notes"))    ; 默认org-roam目录
(setq org-directory (file-truename (concat path-doc "org")))
(setq straight-base-dir path-cache)             ;; 插件目录，自动创建straight
(setq native-comp-eln-load-path
      (list (expand-file-name "eln-cache" path-cache)))     ;; eln缓存文件位置
(setq bookmark-default-file (concat path-cache "bookmarks"))     ;; 书签记录位置
(setq recentf-save-file (concat path-cache "recentf"))     ;; 最近打开的的文件列表记录文件
(setq savehist-file (concat path-cache "mbhis"))     ;; minibuffer history
(setq save-place-file (concat path-cache "place"))     ;; place history
(setq auto-save-file-name-transforms
      `((".*" ,(concat path-cache "autosave/\\1") t)))      ;; 自动保存的文件
(setq backup-directory-alist
      `(("." . ,(concat path-cache "backups"))))            ;; 备份文件



(provide 'init-os)
;;; init-ui.os ends here
