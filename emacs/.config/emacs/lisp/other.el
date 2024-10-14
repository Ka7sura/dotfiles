;;; 其他的配置

(use-package fcitx
     :init
         (setq-default fcitx-remote-command "fcitx5-remote")
    :config
        (setq fcitx-use-dbus "fcitx5")
        (fcitx-aggressive-setup)
             )



(provide 'other)
;;; other.el ends here
