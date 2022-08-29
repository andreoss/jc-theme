;;; jc-obscure-theme.el --- Obscure
;; lexical-binding: t

;; URL: https://gitlab.com/andreoss/jc-theme
;; Keywords: faces
;; Version: 0.2
;; Package-Requires: ((emacs "25"))

;; Local Variables:
;; no-byte-compile: t
;; eval: (rainbow-mode +1)
;; End:

;;; Commentary:
;;; (eval-buffer)
;;; (un-require 'jc)
;;; (enable-theme  'jc-obscure)
;;; (disable-theme 'jc-obscure)

;;; Code:

(require 'jc-themes)

(deftheme jc-obscure
"Abolish syntax highlighting.")

(custom-theme-reset-faces 'jc-obscure)

(defun jc-color-obscure (color)
  "Obscure COLOR."
  (if (jc-color-equal-p color "#ffffea")
      "#000000"
    (jc-color-blend "#313438" (jc-color-inverse color) 0.1)))

(jc--init 'jc-obscure '(jc-color-obscure))
;;;###autoload
(and load-file-name
    (boundp 'custom-theme-load-path)
    (add-to-list 'custom-theme-load-path
                (file-name-as-directory
                (file-name-directory load-file-name))))


(provide-theme 'jc-obscure)
;;; jc-obscure-theme.el ends here
