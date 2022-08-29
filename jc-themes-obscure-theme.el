;;; jc-themes-obscure-theme.el --- Obscure
;; -*- lexical-binding: t -*-

;; URL: https://gitlab.com/andreoss/jc-theme
;; Keywords: faces
;; Version: 0.3
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:
;; XXX

;;; Code:

(require 'jc-themes)
(deftheme jc-themes-obscure "Abolish syntax highlighting.")
(defun jc-themes-colour-obscure (colour)
  "Obscure COLOUR."
  (if (jc-themes-colour-equal-p colour "#FFFFEA")
      "#000000"
    (jc-themes-colour-blend
     "#313438" (jc-themes-colour-inverse colour) 0.1)))
(jc-themes--init 'jc-themes-obscure '(jc-themes-colour-obscure))
(provide-theme 'jc-themes-obscure)
(provide 'jc-themes-obscure-theme)
;;; jc-themes-obscure-theme.el ends here
