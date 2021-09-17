;;; jc-obscure-theme.el --- no colors

;; URL: https://gitlab.com/andreoss/jc-theme
;; Keywords: theme
;; Version: 0.2
;; Package-Requires: ((emacs "25"))

;; Local Variables:
;; no-byte-compile: t
;; lexical-binding: t
;; eval: (rainbow-mode +1)
;; End:

;;; Commentary:
;;; (eval-buffer)
;;; (un-require 'jc)
;;; (enable-theme  'jc)
;;; (disable-theme 'jc)

;;; Code:

(require 'jc-themes)

(deftheme jc-obscure
"Abolish syntax highlighting.")

(custom-theme-reset-faces 'jc-obscure)

(jc--init 'jc-obscure '(jc-color-inverse))

;;;###autoload
(and load-file-name
    (boundp 'custom-theme-load-path)
    (add-to-list 'custom-theme-load-path
                (file-name-as-directory
                (file-name-directory load-file-name))))


(provide-theme 'jc-obscure)
;;; jc-obscure-theme.el ends here
