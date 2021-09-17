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

(eval-when-compile
  (require 'subr-x)
  (require 'cl))

(defun jc-color-split (color)
  "Return '(R G B) for COLOR."
  ;; Not using color-name-to-rbg because
  ;; its result depends on the current frame.
  (let* ((c (string-remove-prefix "#" color))
         (n (string-to-number c 16))
         (r (/ n (* 256 256)))
         (g (/ (- n (* r 256 256)) 256))
         (b (- n (* r 256 256) (* g 256))))
    (list r g b)))

(defun jc-color-make (r g b)
  "Make string to represent R G B color."
  (format "#%02x%02x%02x" (abs (floor r)) (abs (floor g)) (abs (floor b))))

(defun jc-color-grayscale (color)
  "Convert COLOR to grayscale."
  (let* ((rgb (jc-color-split color))
         (a   (floor (apply '+ rgb) 3)))
    (jc-color-make a a a)))

(defun jc-color-inverse (color)
  "Inverse COLOR."
  (let* ((rgb  (jc-color-split color))
         (inv  (mapcar (lambda (a) (- 255 a)) rgb)))
    (apply 'jc-color-make inv)))

(defun jc-color-shade (color &optional grade)
  "Shade of COLOR with GRADE."
  (setq grade (or grade 0.8))
  (let* ((rgb  (jc-color-split color))
         (inv  (mapcar (lambda (a) (* grade a)) rgb)))
    (apply 'jc-color-make inv)))

(defun jc-color-complement (color &optional grade)
  "Complement of COLOR with GRADE."
  (setq grade (or grade 0.8))
  (let* ((rgb  (jc-color-split color))
         (inv  (mapcar (lambda (a) (* grade a)) rgb)))
    (jc-color-make (+ 30 (first rgb)) (* 0.95 (second rgb)) (+ 25 (third rgb)))))

(defun jc-rbg-to-cmyk (color)
  "Convert RGB COLOR to CMYK."
  (let* (
         (rbg (jc-color-split color))
         (r~ (/ (first rbg) 255.0))
         (g~ (/ (second rbg) 255.0))
         (b~ (/ (third rbg) 255.0))
         (k  (- 1 (max r~ b~ g~)))
         (c  (if (= (- 1 k) 0.0) 0.0 (/ (- 1 r~ k) (- 1 k))))
         (m  (if (= (- 1 k) 0.0) 0.0 (/ (- 1 g~ k) (- 1 k))))
         (y  (if (= (- 1 k) 0.0) 0.0 (/ (- 1 b~ k) (- 1 k))))
         )
    (list c m y k))
  )

(defun jc-cmyk-to-rbg (cmyk)
  "Convert CMYK ot RBG."
  (let* (
         (c (first cmyk))
         (m (second cmyk))
         (y (third cmyk))
         (k (fourth cmyk))
         )
    (jc-color-make
     (* 255 (- 1 c) (- 1 k)) (* 255 (- 1 m) (- 1 k)) (* 255 (- 1 y) (- 1 k))))
  )

(defun jc-color-blend (a b prop)
  "Blend color A with color B with PROP."
  (defun jc-zip (&rest xss)
    (if (null (car xss))
    '()
      (cons
       (mapcar #'car xss)
       (apply #'jc-zip (mapcar #'cdr xss)))))
  (let* (
         (a-cmyk (jc-rbg-to-cmyk a))
         (b-cmyk (jc-rbg-to-cmyk b))
         )
    (jc-cmyk-to-rbg
     (mapcar
      (lambda (x)
        (+ (* prop (first x)) (* (- 1 prop) (second x))))
      (jc-zip a-cmyk b-cmyk)))))

(defun jc-color-sepia (color)
  "Convert COLOR to sepia."
  (let* ((rgb (jc-color-split color))
         (r   (first rgb))
         (g   (second rgb))
         (b   (third rgb))
         (coerce #'(lambda (c)     (min 255 (floor c))))
         (adjust #'(lambda (x y z) (funcall coerce (+ (* x r) (* y g) (* z b)))))
         (r~  (funcall adjust 0.393 0.769 0.189))
         (g~  (funcall adjust 0.349 0.686 0.168))
         (b~  (funcall adjust 0.272 0.534 0.131)))
    (jc-color-make r~ g~ b~)))

(defun jc-color-luminance (color)
  "Return luminance [0, 1] of COLOR."
  (let* ((rgb (jc-color-split color))
         (r   (car   rgb)) (r~  (* 0.2126 r))
         (g   (cadr  rgb)) (g~  (* 0.7152 g))
         (b   (caddr rgb)) (b~  (* 0.0722 b))
         (rbg~ (mapcar (lambda (x) (/ x 255)) (list r~ b~ g~))))
    (apply '+ rbg~)))

(defun jc-color-identity (color)
  "Identify COLOR."
  (apply 'jc-color-make (jc-color-split color)))

(defgroup jc-theme nil
  "Options for jc-theme"
  :group 'faces)

(defface jc-empty '((t nil))
  "No colors. Default."
  :group 'jc-theme)

(defcustom jc-background-color "#ffffea"
  "Background color."
  :group 'jc-theme
  :type  'color)

(defcustom jc-red-color "#AE0033"
  "Red color."
  :group 'jc-theme
  :type  'color)

(defcustom jc-yellow-color "#DFDA00"
  "Red color."
  :group 'jc-theme
  :type  'color)

(defcustom jc-blue-color "#0047AE"
  "Red color."
  :group 'jc-theme
  :type  'color)

(defcustom jc-green-color "#00AE47"
  "Red color."
  :group 'jc-theme
  :type  'color)

(defcustom jc-foreground-color (jc-color-inverse jc-background-color)
  "Foreground color."
  :group 'jc-theme
  :type  'color)

(defun jc--combine (fs)
    "Return function composed of FS."
    (lexical-let ((fs! fs))
      (lambda (&rest args)
        (reduce 'funcall (butlast fs!)
                :from-end t
                :initial-value (apply (car (last fs!)) args)))))

(setq jc-color-filter-alist  '(jc-color-inverse))

(defun jc--init (name filters)
  "Initialise."
  (let* ((f  (jc--combine (cons 'jc-color-identity filters)) )
         ;; Ignore 256-color terminals
         (g '((class color) (min-colors 257)))

         (∅ '((t nil)))

         ;; Background
         (bg (funcall f jc-background-color))
         ;; Foreground
         (fg (funcall f jc-foreground-color))
         ;; Mode line
         (m  (jc-color-shade bg))
         ;; Shade
         (shade-1  (jc-color-shade bg 0.95))
         (shade-2  (jc-color-shade bg 0.90))
         (shade-3  (jc-color-shade bg 0.85))
         (shade-4  (jc-color-shade bg 0.80))
         (shade-5  (jc-color-shade bg 0.75))
         (shade-6  (jc-color-shade bg 0.75))
         ;; Inactive mode-line text color
         (i  (jc-color-grayscale m))
         ;; Scroll bar
         (k  (jc-color-shade bg))
         ;; Red
         (a  jc-red-color)
         ;; String literals underline color
         (s  (jc-color-blend jc-green-color jc-background-color 0.1))
         ;; Green
         (z  jc-green-color)
         ;; Region
         (r (jc-color-shade jc-green-color))
         ;; Orange
         (or (jc-color-blend jc-yellow-color jc-red-color 0.7))

         ;; Links
         (l1 (jc-color-shade jc-blue-color 0.9))
         (l2 (jc-color-shade jc-blue-color 0.8))
         (l3 (jc-color-shade jc-blue-color 0.7))

         ;; Hihglight
         (hl (jc-color-blend jc-background-color (jc-color-shade jc-green-color) 0.6))

         (bold    '(:weight  bold))
         (default '(:inherit default)))
    (custom-theme-set-faces
     name
     `(default     ((,g (:background ,bg :foreground ,fg))))
     `(border      ((,g (:background ,fg))))

     `(mode-line   ((,g (:background ,m
                                     :box (:line-width    -1
                                                          :color        ,k
                                                          :style         released-button
                                                          )
                                     ))))

     `(mode-line-buffer-id ((t (,@bold))))
     `(mode-line-emphasis  ((t (,@bold))))

     `(mode-line-inactive  ((,g (
                                 :inherit mode-line
                                 :background ,bg
                                 :foreground ,i
                                 ))
                            (t (:background "gray" :foreground "#000000"))))

     `(header-line  ( (t   (:inherit mode-line))))
     `(link                ( (,g  (:underline ,l1))))
     `(link-visited        ( (,g  (:underline ,l2 :inherit link))))
     `(custom-link         ( (,g  (:underline ,l3 :inherit link))))
     `(error               ( (,g  (:underline ,a  ,@bold))))
     `(warning             ( (,g  (:underline ,or ,@bold))))
     `(success             ( (,g  (:underline ,z  ,@bold))))
     `(highlight           ( (,g  (:background ,hl
                                               :foreground ,fg
                                               ,@bold))))
     ;; Comments
     `(font-lock-comment-face ,∅)

     `(font-lock-comment-delimiter-face
       ((t (,@bold))))

     ;; Scroll-bar
     `(scroll-bar         ((,g  (:background ,bg :foreground ,k ,@default))))

     `(minibuffer-prompt  ((t  (,@bold ,@default))))

     `(font-lock-builtin-face        ,∅)
     `(font-lock-constant-face       ,∅)
     `(font-lock-doc-face            ((t  (:inherit font-lock-comment-face))))
     `(font-lock-function-name-face  ,∅)
     `(font-lock-keyword-face        ,∅)

     `(font-lock-negation-char-face  ,∅)
     `(font-lock-preprocessor-face   ,∅)

     `(font-lock-regexp-grouping-backslash  ,∅)
     `(font-lock-regexp-grouping-construct  ,∅)

     `(font-lock-string-face         ((,g  (:underline ,s)) ,@∅))

     `(region                         ((,g (:background  ,r))
                                       (t   (:inverse-video t))))

     `(font-lock-type-face           ,∅)
     `(font-lock-variable-name-face  ,∅)
     `(font-lock-warning-name-face   ((t  (,@bold ))))

     `(rainbow-delimiters-depth-1-face ,∅)
     `(rainbow-delimiters-depth-2-face ,∅)
     `(rainbow-delimiters-depth-3-face ,∅)
     `(rainbow-delimiters-depth-4-face ,∅)
     `(rainbow-delimiters-depth-5-face ,∅)
     `(rainbow-delimiters-depth-6-face ,∅)
     `(rainbow-delimiters-depth-7-face ,∅)
     `(rainbow-delimiters-depth-8-face ,∅)
     `(rainbow-delimiters-depth-9-face ,∅)

     ;; Parens matching
     `(show-paren-match    ((,g (:inherit highlight))
                            (t  (:inverse-video t))))

     `(show-paren-mismatch ((t (:strike-through t :inherit error))))

     `(fringe          ((t (,@default))))
     `(isearch         ((t (:underline (:color foreground-color :style wave)))))
     `(lazy-highlight  ((t (:inherit highlight))))

     ;; Misc
     `(escape-glyph        ((t (:inherit error))))
     `(trailing-whitespace ((t (:underline (:inherit error :style wave)))))

     ;; Outline
     `(outline-1 ,∅)
     `(outline-2 ,∅)
     `(outline-3 ,∅)
     `(outline-4 ,∅)
     `(outline-5 ,∅)
     `(outline-6 ,∅)
     `(outline-7 ,∅)

     ;; Dired
     `(dired-subtree-depth-1-face   ((t (:background ,shade-1))))
     `(dired-subtree-depth-2-face   ((t (:background ,shade-2))))
     `(dired-subtree-depth-3-face   ((t (:background ,shade-3))))
     `(dired-subtree-depth-4-face   ((t (:background ,shade-4))))
     `(dired-subtree-depth-5-face   ((t (:background ,shade-5))))
     `(dired-subtree-depth-6-face   ((t (:background ,shade-6))))

     `(cperl-array-face           ,∅)
     `(cperl-hash-face            ,∅)
     `(cperl-nonoverridable-face  ,∅)

     `(fixed-pitch        ,∅)
     `(fixed-pitch-serif  ,∅)
     `(variable-pitch     ,∅)

     `(eshell-prompt         ,∅)
     `(eshell-ls-executable  ,∅)
     `(eshell-ls-backup      ,∅)
     `(eshell-ls-directory   ,∅)
     `(eshell-ls-archive     ,∅)
     `(eshell-ls-product     ,∅)
     `(eshell-ls-symlink     ,∅)
     `(eshell-ls-clutter     ,∅)
     `(eshell-ls-unreadable  ,∅)
     `(eshell-ls-missing     ,∅)
     `(eshell-ls-special     ,∅)

     `(highlight-changes     ((t (:inherit highlight))))

     `(org-todo    ((,g (,@bold :foreground ,a))))
     `(org-done    ((,g (,@bold :foreground ,z))))
     `(org-level-1 ((,g (,@bold))))
     `(org-block   ((,g (:background ,shade-1 :extend t))))

     `(cider-result-overlay-face ((,g (:background  ,m :box (:line-width -1 :style released-button)))
                                  (t (:inverse-video t)))))

    `(sh-quoted-exec ,∅)

    `(flycheck-error        ((,g (:underline (:style wave :color ,r) ))))
    `(flycheck-warning      ((,g (:underline (:style wave :color ,or)))))
    `(flycheck-info         ((,g (:underline (:style wave :color ,s) ))))
    `(flyspell-incorrect    ((,g (:underline (:style wave :color ,r) ))))
    `(fill-column-indicator ((,g (:foreground ,shade-1))))
    ))

(provide 'jc-base)
;;; jc-theme ends here
