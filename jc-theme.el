;;; jc-theme.el --- no colors

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
(deftheme jc
  "Abolish syntax highlighting.")
(custom-theme-reset-faces 'jc)
(jc--init 'jc '())

(provide-theme 'jc)
;;; jc-theme.el ends here
