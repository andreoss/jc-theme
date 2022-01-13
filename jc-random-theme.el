;;; jc-random-theme.el --- no colors

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
;;; (enable-theme  'jc-random)
;;; (disable-theme 'jc-random)

;;; Code:

(require 'jc-themes)

(deftheme jc-random
"Abolish syntax highlighting. Random.")

(custom-theme-reset-faces 'jc-random)

(setq jc-colors '(
                  "#ae4444"
                  "#96ea44"
                  "#9644ae"
                  "#4444aa"
                  )
      )
(setq jc-color-random
  (jc-color-identity
   (nth (mod (random ) (length jc-colors)) jc-colors)))

(defun jc-color-randomish (color)
  "Mix with a COLOR."
  (jc-color-blend jc-color-random color 0.2)
  )

(jc--init 'jc-random '(jc-color-randomish))

;;;###autoload
(and load-file-name
    (boundp 'custom-theme-load-path)
    (add-to-list 'custom-theme-load-path
                (file-name-as-directory
                (file-name-directory load-file-name))))


(provide-theme 'jc-random)
;;; jc-random-theme.el ends here
