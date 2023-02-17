;;; jc-themes-turbo-theme.el --- Turbo
;; -*- lexical-binding: t -*-

;; URL: https://gitlab.com/andreoss/jc-theme
;; Keywords: faces
;; Version: 0.3
;; SPDX-License-Identifier: GPL-3.0-or-later

;;; Commentary:
;; XXX

;;; Code:
(require 'jc-themes)
(deftheme jc-themes-turbo "Abolish syntax highlighting. Turbo")

(let ((jc-themes-background-colour jc-themes-blue-colour)
      (jc-themes-foreground-colour jc-themes-yellow-colour))
  (jc-themes--init 'jc-themes-turbo '())
  )
(provide-theme 'jc-themes-turbo)
(provide 'jc-themes-turbo-themes)
;;; jc-themes-turbo-theme.el ends here
