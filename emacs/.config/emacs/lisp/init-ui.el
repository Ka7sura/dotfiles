;;; ui初始化

;;; bar mode
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))      ;关闭工具栏
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))  ;关闭显示滚动条
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))      ;关闭菜单栏
(push '(scroll-bar-mode . nil) default-frame-alist)
(push '(tool-bar-mode . nil) default-frame-alist)
(push '(menu-bar-mode . nil) default-frame-alist)

(setq inhibit-startup-message t)        ; 关闭启动时的欢迎界面
(global-hl-line-mode 1)                 ; 高亮当前行

;Theme
(load-theme 'leuven-dark t) ;; Load a custom theme，Emacs>=29
;; (load-theme 'misterioso t)

;;; 左侧
(global-display-line-numbers-mode t)        ; 显示行号
(setq display-line-numbers-type 'relative)      ; 相对行号

;;; modeline
(add-hook 'after-init-hook #'size-indication-mode)  ; 显示文件大小
(column-number-mode t)                  ; 显示行列号（原版只显示行号）

;;; cursor
(setq-default cursor-type 'bar) ; 设置光标为竖线



;;; Fonts
(defvar ui--fonts-default '("LXGW WenKai Mono" "JetBrainsMonoNL Nerd Font Mono"))      ;默认字体
(defvar ui--fonts-unicode '("Segoe UI Symbol" "Symbola" "Symbol"))  ;Unicode字符
(defvar ui--fonts-emoji '("Noto Color Emoji" "Apple Color Emoji"))  ;表情
(defvar ui--fonts-cjk '("Jigmo" "STKaiTi" "WenQuanYi Micro Hei"))   ;CJK字符集

;; 更改显示字体大小 16pt
;; http://stackoverflow.com/questions/294664/how-to-set-the-font-size-in-emacs
(set-face-attribute 'default nil :height 120);;

(require 'subr-x) ;; cl-loop来自这里

(defun ui--set-font-common (character font-list &optional scale-factor) "从 FONT-LIST 中设置特定字符集的字体，并且可以使用scale-factor来调整字体的大小。"
  (cl-loop for font in font-list
       when (find-font (font-spec :name font))
       return (if (not character) (set-face-attribute 'default nil :family font)    ;set default
            (when scale-factor (setq face-font-rescale-alist `((,font . ,scale-factor))))
            (set-fontset-font t character (font-spec :family font) nil 'prepend))))

(defun ui--font-setup (&optional default-fonts unicode-fonts emoji-fonts cjk-fonts)
  "字体设置, 可选：DEFAULT-FONTS, UNICODE-FONTS, EMOJI-FONTS, CJK-FONTS."
  (interactive)
  (when (display-graphic-p)
    (ui--set-font-common nil (if default-fonts default-fonts ui--fonts-default))
    (ui--set-font-common 'unicode (if unicode-fonts unicode-fonts ui--fonts-unicode))
    (ui--set-font-common 'emoji (if emoji-fonts emoji-fonts ui--fonts-emoji))
    (dolist (charset '(kana han bopomofo cjk-misc))
      (ui--set-font-common charset (if cjk-fonts cjk-fonts ui--fonts-cjk) 1.2))))



(provide 'init-ui)
;;; init-ui.el ends here
