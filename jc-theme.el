;;; jc-theme.el --- Light
;; lexical-binding: t

;; URL: https://gitlab.com/andreoss/jc-theme
;; Keywords: faces
;; Version: 0.3
;; SPDX-License-Identifier: GPL-3.0-or-later
;; Package-Requires: ((emacs "25"))

;; Local Variables:
;; no-byte-compile: t
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
