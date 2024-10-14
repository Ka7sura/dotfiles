;;; 快速启动

; 先将垃圾回收的阈值设置到最大可能的整数值，在Emacs初始化后hook，将垃圾回收的阈值设置为800000（default）
(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'after-init-hook #'(lambda () (setq gc-cons-threshold 800000)))



(provide 'init-qstart)
;;; init-qstart.el ends here
