;;; jc-themes.el --- No colors

;; URL: https://gitlab.com/andreoss/jc-theme
;; Keywords: theme
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

(require 'jc)

;;;###autoload
(when (and (boundp 'custom-theme-load-path) load-file-name)
  (let* ((base (file-name-directory load-file-name))
         (dir (expand-file-name "themes/" base)))
    (add-to-list 'custom-theme-load-path
                 (or (and (file-directory-p dir) dir)
                     base))))


(provide 'jc-themes)
;;; jc-themes.el ends here
