;;; jc-themes-red-theme.el --- Random
;; -*- lexical-binding: t -*-

;; URL: https://gitlab.com/andreoss/jc-theme
;; Keywords: faces
;; Version: 0.3
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:
;; XXX

;;; Code:
(require 'jc-themes)
(deftheme jc-themes-red "Abolish syntax highlighting.  Red.")

(defun jc-themes-red-colour-blend (colour)
  "Mix with red COLOUR."
  (if (< (jc-themes-colour-luminance colour) 0.01)
      colour
    (jc-themes-colour-blend jc-themes-red-colour colour 0.3)))

(let ((jc-themes-background-colour "#FFFFAA")
      (jc-themes-foreground-colour "#000000"))
  (jc-themes--init 'jc-themes-red '(jc-themes-red-colour-blend)))
(provide-theme 'jc-themes-red)
(provide 'jc-themes-red-theme)
;;; jc-themes-red-theme.el ends here
