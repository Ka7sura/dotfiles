;;; LSP config

;; lsp-mode     - 基于Lisp          功能丰富
;; lsp-bridge   - 基于py的          配置简单
;; eglot        - 基于Lisp bulltin  小巧

;; (use-package eglot)
;; (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
;; (add-hook 'c-mode-hook #'eglot-ensure)
;; (add-hook 'c++-mode-hook #'eglot-ensure)

(require 'eglot)
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
(add-hook 'c-mode-hook #'eglot-ensure)
(add-hook 'c++-mode-hook #'eglot-ensure)


(provide 'plugin-lsp)
;;; plugin-lsp.el ends here
