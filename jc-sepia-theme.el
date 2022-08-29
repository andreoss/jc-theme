;;; jc-sepia-theme.el --- Sepia
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
;;; (enable-theme  'jc)
;;; (disable-theme 'jc)

;;; Code:

(require 'jc-themes)

(deftheme jc-sepia
"Abolish syntax highlighting.")

(custom-theme-reset-faces 'jc-sepia)

(jc--init 'jc-sepia '(jc-color-sepia))

;;;###autoload
(and load-file-name
    (boundp 'custom-theme-load-path)
    (add-to-list 'custom-theme-load-path
                (file-name-as-directory
                (file-name-directory load-file-name))))

(provide-theme 'jc-sepia)
;;; jc-sepia-theme.el ends here
