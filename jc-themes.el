;;; jc-themes.el --- Themes
;; -*- lexical-binding: t -*-

;; URL: https://gitlab.com/andreoss/jc-theme
;; Keywords: faces
;; Version: 0.3
;; SPDX-License-Identifier: GPL-3.0-or-later
;; Package-Requires: ((emacs "25"))

;;; Commentary:
;; XXX

;;; Code:

(eval-when-compile
  (require 'subr-x)
  (require 'cl-lib))

(defun jc-themes-colour-split (colour)
  "Return '(R G B) for COLOUR."
  ;; Not using colour-name-to-rbg because
  ;; its result depends on the current frame.
  (let* ((c (string-remove-prefix "#" colour))
         (n (string-to-number c 16))
         (r (/ n (* 256 256)))
         (g (/ (- n (* r 256 256)) 256))
         (b (- n (* r 256 256) (* g 256))))
    (list r g b)))

(defun jc-themes-colour-make (r g b)
  "Make string to represent R G B colour."
  (format "#%02x%02x%02x"
          (abs (floor r))
          (abs (floor g))
          (abs (floor b))))

(defun jc-themes-colour-grayscale (colour)
  "Convert COLOUR to grey-scale."
  (let* ((rgb (jc-themes-colour-split colour))
         (a (floor (apply #'+ rgb) 3)))
    (jc-themes-colour-make a a a)))

(defun jc-themes-colour-inverse (colour)
  "Inverse COLOUR."
  (let* ((rgb (jc-themes-colour-split colour))
         (inv (mapcar (lambda (a) (- 255 a)) rgb)))
    (apply #'jc-themes-colour-make inv)))

(defun jc-themes-colour-shade (colour &optional grade)
  "Shade of COLOUR with GRADE."
  (setq grade (or grade 0.8))
  (let* ((rgb (jc-themes-colour-split colour))
         (mul
          (if (> 0.5 (jc-themes-colour-luminance colour))
              (+ 1.0 grade)
            grade))
         (inv (mapcar (lambda (a) (* mul a)) rgb)))
    (apply #'jc-themes-colour-make inv)))

(defun jc-themes-colour-complement (colour &optional grade)
  "Complement of COLOUR with GRADE."
  (setq grade (or grade 0.8))
  (let* ((rgb (jc-themes-colour-split colour))
         (inv (mapcar (lambda (a) (* grade a)) rgb)))
    (jc-themes-colour-make
     (+ 30 (cl-first rgb))
     (* 0.95 (cl-second rgb))
     (+ 25 (cl-third rgb)))))

(defun jc-themes-rbg-to-cmyk (colour)
  "Convert RGB COLOUR to CMYK."
  (let* ((rbg (jc-themes-colour-split colour))
         (r~ (/ (cl-first rbg) 255.0))
         (g~ (/ (cl-second rbg) 255.0))
         (b~ (/ (cl-third rbg) 255.0))
         (k (- 1 (max r~ b~ g~)))
         (c
          (if (= (- 1 k) 0.0)
              0.0
            (/ (- 1 r~ k) (- 1 k))))
         (m
          (if (= (- 1 k) 0.0)
              0.0
            (/ (- 1 g~ k) (- 1 k))))
         (y
          (if (= (- 1 k) 0.0)
              0.0
            (/ (- 1 b~ k) (- 1 k)))))
    (list c m y k)))

(defun jc-themes-cmyk-to-rbg (cmyk)
  "Convert CMYK to RBG."
  (let* ((c (cl-first cmyk))
         (m (cl-second cmyk))
         (y (cl-third cmyk))
         (k (cl-fourth cmyk)))
    (jc-themes-colour-make
     (* 255 (- 1 c) (- 1 k))
     (* 255 (- 1 m) (- 1 k))
     (* 255 (- 1 y) (- 1 k)))))

(defun jc-themes-zip (&rest xss)
  "Zip XSS."
  (if (null (car xss))
      '()
    (cons
     (mapcar #'car xss) (apply #'jc-themes-zip (mapcar #'cdr xss)))))
(defun jc-themes-colour-blend (a b prop)
  "Blend colour A with colour B with PROP."
  (let* ((a-cmyk (jc-themes-rbg-to-cmyk a))
         (b-cmyk (jc-themes-rbg-to-cmyk b)))
    (jc-themes-cmyk-to-rbg
     (mapcar
      (lambda (x)
        (+ (* prop (cl-first x)) (* (- 1 prop) (cl-second x))))
      (jc-themes-zip a-cmyk b-cmyk)))))

(defun jc-themes-colour-sepia (colour)
  "Convert COLOUR to sepia."
  (let* ((rgb (jc-themes-colour-split colour))
         (r (cl-first rgb))
         (g (cl-second rgb))
         (b (cl-third rgb))
         (coerce (lambda (c) (min 255 (floor c))))
         (adjust
          (lambda (x y z)
            (funcall coerce (+ (* x r) (* y g) (* z b)))))
         (r~ (funcall adjust 0.393 0.769 0.189))
         (g~ (funcall adjust 0.349 0.686 0.168))
         (b~ (funcall adjust 0.272 0.534 0.131)))
    (jc-themes-colour-make r~ g~ b~)))

(defun jc-themes-colour-luminance (colour)
  "Return luminance [0, 1] of COLOUR."
  (let* ((rgb (jc-themes-colour-split colour))
         (r (car rgb))
         (r~ (* 0.2126 r))
         (g (cadr rgb))
         (g~ (* 0.7152 g))
         (b (caddr rgb))
         (b~ (* 0.0722 b))
         (rbg~ (mapcar (lambda (x) (/ x 255)) (list r~ b~ g~))))
    (apply #'+ rbg~)))

(defun jc-themes-colour-identity (colour)
  "Identify COLOUR."
  (apply #'jc-themes-colour-make (jc-themes-colour-split colour)))

(defun jc-themes-colour-equal-p (a b)
  "Is A the same colour B."
  (equal (jc-themes-colour-identity a) (jc-themes-colour-identity b)))

(defgroup jc-themes nil
  "Options for jc-theme."
  :group 'faces)

(defface jc-themes-empty '((t nil))
  "No colours.  Default."
  :group 'jc-themes)

(defcustom jc-themes-white-colour "#FFFFEA"
  "White colour."
  :group 'jc-themes
  :type 'colour)

(defcustom jc-themes-black-colour "#101010"
  "Black colour."
  :group 'jc-themes
  :type 'colour)

(defcustom jc-themes-red-colour "#C9002B"
  "Red colour."
  :group 'jc-themes
  :type 'colour)

(defcustom jc-themes-yellow-colour "#F8CD24"
  "Red colour."
  :group 'jc-themes
  :type 'colour)

(defcustom jc-themes-blue-colour "#004B93"
  "Red colour."
  :group 'jc-themes
  :type 'colour)

(defcustom jc-themes-green-colour "#3C6255"
  "Red colour."
  :group 'jc-themes
  :type 'colour)

(defcustom jc-themes-background-colour jc-themes-white-colour
  "Background colour."
  :group 'jc-themes
  :type 'colour)

(defcustom jc-themes-foreground-colour
  (jc-themes-colour-inverse jc-themes-background-colour)
  "Foreground colour."
  :group 'jc-themes
  :type 'colour)

(defmacro jc-themes--combine (fs)
  "Return function composed of FS."
  `(lambda (&rest args)
     (cl-reduce
      'funcall
      (butlast ,fs)
      :from-end t
      :initial-value (apply (car (last ,fs)) args))))

(defun jc-themes-colour-bright (colour &optional grade)
  "Complement of COLOUR with GRADE."
  (jc-themes-colour-blend
   colour jc-themes-white-colour (or grade 0.60)))

(defun jc-themes--make-foreground-colour (c)
  "Foreground C."
  (list (list t (list :foreground c))))

(defun jc-themes--make-background-colour (c)
  "Background C."
  (list (list t (list :background c))))

(defun jc-themes--make-background-colour-extend (c)
  "Background with extend C."
  (list (list t (list :background c :extend t))))

(defun jc-themes--make-solid-colour (c)
  "Solid C."
  (list (list t (list :background c :foreground c))))

(defun jc-themes-git-gutter-colours ()
  "Make git-gutter colours."
  (let* ((magenta-colour
          (jc-themes-colour-blend
           jc-themes-blue-colour jc-themes-red-colour 0.5)))
    (list
     (list
      'git-gutter:added
      (jc-themes--make-solid-colour
       (jc-themes-colour-blend
        jc-themes-background-colour jc-themes-green-colour 0.15)))
     (list
      'git-gutter:deleted
      (jc-themes--make-solid-colour
       (jc-themes-colour-blend
        jc-themes-background-colour jc-themes-red-colour 0.15)))
     (list
      'git-gutter:modified
      (jc-themes--make-solid-colour
       (jc-themes-colour-blend
        jc-themes-background-colour magenta-colour 0.15))))))

(defun jc-themes-ansi-colours ()
  "Make ansi-colours."
  (let* ((magenta-colour
          (jc-themes-colour-blend
           jc-themes-blue-colour jc-themes-red-colour 0.5))
         (cyan-colour
          (jc-themes-colour-blend
           jc-themes-blue-colour jc-themes-green-colour 0.5)))
    (list
     (list
      'ansi-color-bright-white
      (jc-themes--make-solid-colour
       (jc-themes-colour-bright jc-themes-white-colour)))
     (list
      'ansi-color-white
      (jc-themes--make-solid-colour jc-themes-white-colour))
     (list
      'ansi-color-bright-black
      (jc-themes--make-solid-colour
       (jc-themes-colour-bright jc-themes-black-colour)))
     (list
      'ansi-color-black
      (jc-themes--make-solid-colour jc-themes-black-colour))
     (list
      'ansi-color-bright-yellow
      (jc-themes--make-solid-colour
       (jc-themes-colour-bright jc-themes-yellow-colour)))
     (list
      'ansi-color-bright-blue
      (jc-themes--make-solid-colour
       (jc-themes-colour-bright jc-themes-blue-colour)))
     (list
      'ansi-color-bright-red
      (jc-themes--make-solid-colour
       (jc-themes-colour-bright jc-themes-red-colour)))
     (list
      'ansi-color-bright-green
      (jc-themes--make-solid-colour
       (jc-themes-colour-bright jc-themes-green-colour)))
     (list
      'ansi-color-blue
      (jc-themes--make-solid-colour jc-themes-blue-colour))
     (list
      'ansi-color-green
      (jc-themes--make-solid-colour jc-themes-green-colour))
     (list
      'ansi-color-red
      (jc-themes--make-solid-colour jc-themes-red-colour))
     (list
      'ansi-color-bright-cyan
      (jc-themes--make-solid-colour
       (jc-themes-colour-bright cyan-colour)))
     (list
      'ansi-color-cyan (jc-themes--make-solid-colour cyan-colour))
     (list
      'ansi-color-bright-magenta
      (jc-themes--make-solid-colour
       (jc-themes-colour-bright magenta-colour)))
     (list
      'ansi-color-magenta
      (jc-themes--make-solid-colour magenta-colour)))))

(defun jc-themes--init (name transformers)
  "Initialise NAME theme with TRANSFORMERS."
  (let* ((f
          (jc-themes--combine
           (cons 'jc-themes-colour-identity transformers)))
         ;; Ignore 256-colour terminals
         (g '((class color) (min-colors 257)))

         (∅ '((t nil)))

         ;; Background
         (bg (funcall f jc-themes-background-colour))
         ;; Foreground
         (fg (funcall f jc-themes-foreground-colour))
         ;; Mode line
         (m (jc-themes-colour-shade bg))
         ;; Shade
         (shade-1
          (funcall f
                   (jc-themes-colour-shade jc-themes-background-colour
                                           0.95)))
         (shade-2
          (funcall f
                   (jc-themes-colour-shade jc-themes-background-colour
                                           0.85)))
         (shade-3
          (funcall f
                   (jc-themes-colour-shade jc-themes-background-colour
                                           0.75)))
         (shade-4
          (funcall f
                   (jc-themes-colour-shade jc-themes-background-colour
                                           0.65)))
         (shade-5
          (funcall f
                   (jc-themes-colour-shade jc-themes-background-colour
                                           0.55)))
         (shade-6
          (funcall f
                   (jc-themes-colour-shade jc-themes-background-colour
                                           0.45)))
         ;; Inactive mode-line text colour
         (i (jc-themes-colour-grayscale m))
         ;; Scroll bar
         (k (jc-themes-colour-shade bg))
         ;; Red
         (a jc-themes-red-colour)
         ;; String literals underline colour
         (s
          (funcall f
                   (jc-themes-colour-blend
                    jc-themes-green-colour
                    jc-themes-background-colour
                    0.1)))
         ;; Green
         (z jc-themes-green-colour)
         ;; Region
         (r
          (funcall f (jc-themes-colour-shade jc-themes-green-colour)))
         ;; Orange
         (or (jc-themes-colour-blend
              jc-themes-yellow-colour jc-themes-red-colour 0.7))

         ;; Links
         (l1 (jc-themes-colour-shade jc-themes-blue-colour 0.9))
         (l2 (jc-themes-colour-shade jc-themes-blue-colour 0.8))
         (l3 (jc-themes-colour-shade jc-themes-blue-colour 0.7))

         ;; Highlight
         (hl
          (jc-themes-colour-blend
           bg
           (jc-themes-colour-shade jc-themes-green-colour) 0.6))
         (bold '(:weight bold))
         (default '(:inherit default)))
    (custom-theme-reset-faces name)
    (cl-loop
     for
     x
     in
     (jc-themes-ansi-colours)
     do
     (custom-theme-set-faces name x))
    (cl-loop
     for
     x
     in
     (jc-themes-git-gutter-colours)
     do
     (custom-theme-set-faces name x))
    (custom-theme-set-faces name
                            (list
                             'dired-subtree-depth-1-face
                             (jc-themes--make-background-colour-extend
                              shade-1))
                            (list
                             'dired-subtree-depth-2-face
                             (jc-themes--make-background-colour-extend
                              shade-2))
                            (list
                             'dired-subtree-depth-3-face
                             (jc-themes--make-background-colour-extend
                              shade-3))
                            (list
                             'dired-subtree-depth-4-face
                             (jc-themes--make-background-colour-extend
                              shade-4))
                            (list
                             'dired-subtree-depth-5-face
                             (jc-themes--make-background-colour-extend
                              shade-5))
                            (list
                             'dired-subtree-depth-6-face
                             (jc-themes--make-background-colour-extend
                              shade-6)))
    (custom-theme-set-faces
     name
     `(default ((,g (:background ,bg :foreground ,fg))))
     `(border ((,g (:background ,fg))))

     `(mode-line
       ((,g
         (:background
          ,m
          :box (:line-width -1 :color ,k :style released-button)))))
     `(mode-line-buffer-id ((t (,@bold))))
     `(mode-line-emphasis ((t (,@bold))))

     `(mode-line-inactive
       ((,g (:inherit mode-line :background ,bg :foreground ,i))))

     `(link ((,g (:underline ,l1))))
     `(link-visited ((,g (:underline ,l2 :inherit link))))
     `(custom-link ((,g (:underline ,l3 :inherit link))))
     `(error ((,g (:underline ,a ,@bold))))
     `(warning ((,g (:underline ,or ,@bold))))
     `(success ((,g (:underline ,z ,@bold))))
     `(highlight ((,g (:background ,hl :foreground ,fg ,@bold))))
     ;; Comments
     `(font-lock-comment-face ,∅)

     `(font-lock-comment-delimiter-face ((t (,@bold))))

     ;; Scroll-bar
     `(scroll-bar ((,g (:background ,bg :foreground ,k ,@default))))

     `(minibuffer-prompt ((t (,@bold ,@default))))

     `(font-lock-builtin-face ,∅)
     `(font-lock-constant-face ,∅)
     `(font-lock-doc-face ((t (:inherit font-lock-comment-face))))
     `(font-lock-function-name-face ,∅)
     `(font-lock-keyword-face ,∅)

     `(font-lock-negation-char-face ,∅)
     `(font-lock-preprocessor-face ,∅)

     `(font-lock-regexp-grouping-backslash ,∅)
     `(font-lock-regexp-grouping-construct ,∅)
     `(font-lock-string-face ,∅)

     `(region ((,g (:background ,r)) (t (:inverse-video t))))

     `(font-lock-type-face ,∅)
     `(font-lock-variable-name-face ,∅)
     `(font-lock-warning-name-face ((t (,@bold))))

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
     `(show-paren-match
       ((,g (:inherit highlight)) (t (:inverse-video t))))

     `(show-paren-mismatch ((t (:strike-through t :inherit error))))
     `(fringe ((t (,@default))))
     `(isearch
       ((t (:underline (:color foreground-color :style wave))))
       `(lazy-highlight ((t (:inherit highlight))))

       ;; Misc
       `(escape-glyph ((t (:inherit error))))
       `(trailing-whitespace
         ((t (:underline (:inherit error :style wave)))))

       ;; Outline
       `(outline-1 ,∅)
       `(outline-2 ,∅)
       `(outline-3 ,∅)
       `(outline-4 ,∅)
       `(outline-5 ,∅)
       `(outline-6 ,∅)
       `(outline-7 ,∅)

       ;; Dired
       `(dired-subtree-depth-1-face
         (jc-themes--make-background-colour-extend ,shade-1))
       `(dired-subtree-depth-2-face
         (jc-themes--make-background-colour-extend ,shade-2))
       `(dired-subtree-depth-3-face
         (jc-themes--make-background-colour-extend ,shade-3))
       `(dired-subtree-depth-4-face
         (jc-themes--make-background-colour-extend ,shade-4))
       `(dired-subtree-depth-5-face
         (jc-themes--make-background-colour-extend ,shade-5))
       `(dired-subtree-depth-6-face
         (jc-themes--make-background-colour-extend ,shade-6))

       `(cperl-array-face ,∅)
       `(cperl-hash-face ,∅)
       `(cperl-nonoverridable-face ,∅)

       `(fixed-pitch ,∅)
       `(fixed-pitch-serif ,∅)
       `(variable-pitch ,∅)

       `(eshell-prompt ,∅)
       `(eshell-ls-executable ,∅)
       `(eshell-ls-backup ,∅)
       `(eshell-ls-directory ,∅)
       `(eshell-ls-archive ,∅)
       `(eshell-ls-product ,∅)
       `(eshell-ls-symlink ,∅)
       `(eshell-ls-clutter ,∅)
       `(eshell-ls-unreadable ,∅)
       `(eshell-ls-missing ,∅)
       `(eshell-ls-special ,∅)

       `(highlight-changes ((t (:inherit highlight))))

       `(org-todo ((,g (,@bold :foreground ,a))))
       `(org-done ((,g (,@bold :foreground ,z))))
       `(org-level-1 ((,g (,@bold))))
       `(org-block ((,g (:background ,shade-1 :extend t))))

       `(cider-result-overlay-face
         ((,g
           (:background
            ,m
            :box (:line-width -1 :style released-button)))
          (t (:inverse-video t)))))

     `(sh-quoted-exec ,∅)


     `(flycheck-error ((,g (:underline (:style wave :color ,r)))))
     `(flycheck-warning ((,g (:underline (:style wave :color ,or)))))
     `(flycheck-info ((,g (:underline (:style wave :color ,s)))))
     `(flyspell-incorrect ((,g (:underline (:style wave :color ,r)))))
     `(fill-column-indicator ((,g (:foreground ,shade-1))))
     `(header-line ((,g (:background ,shade-1))))
     `(header-line-highlight ((,g (:background ,shade-3))))
     `(tooltip ((,g (:background ,shade-1))))
     `(tool-bar ((,g (:background ,shade-1)))))))

(defun jc-themes--init-faces (name transformers)
  "Initialise NAME theme with TRANSFORMERS."
  (let* ((f
          (jc-themes--combine
           (cons 'jc-themes-colour-identity transformers)))
         ;; Ignore 256-colour terminals
         (g '((class color) (min-colors 257)))

         (∅ '((t nil)))

         ;; Background
         (bg (funcall f jc-themes-background-colour))
         ;; Foreground
         (fg (funcall f jc-themes-foreground-colour))
         ;; Mode line
         (m (jc-themes-colour-shade bg))
         ;; Shade
         (shade-1
          (funcall f
                   (jc-themes-colour-shade jc-themes-background-colour
                                           0.95)))
         (shade-2
          (funcall f
                   (jc-themes-colour-shade jc-themes-background-colour
                                           0.85)))
         (shade-3
          (funcall f
                   (jc-themes-colour-shade jc-themes-background-colour
                                           0.75)))
         (shade-4
          (funcall f
                   (jc-themes-colour-shade jc-themes-background-colour
                                           0.65)))
         (shade-5
          (funcall f
                   (jc-themes-colour-shade jc-themes-background-colour
                                           0.55)))
         (shade-6
          (funcall f
                   (jc-themes-colour-shade jc-themes-background-colour
                                           0.45)))
         ;; Inactive mode-line text colour
         (i (jc-themes-colour-grayscale m))
         ;; Scroll bar
         (k (jc-themes-colour-shade bg))
         ;; Red
         (a jc-themes-red-colour)
         ;; String literals underline colour
         (s
          (funcall f
                   (jc-themes-colour-blend
                    jc-themes-green-colour
                    jc-themes-background-colour
                    0.1)))
         ;; Green
         (z jc-themes-green-colour)
         ;; Region
         (r (jc-themes-colour-shade jc-themes-green-colour))
         ;; Orange
         (or (jc-themes-colour-blend
              jc-themes-yellow-colour jc-themes-red-colour 0.7))

         ;; Links
         (l1 (jc-themes-colour-shade jc-themes-blue-colour 0.9))
         (l2 (jc-themes-colour-shade jc-themes-blue-colour 0.8))
         (l3 (jc-themes-colour-shade jc-themes-blue-colour 0.7))

         ;; Highlight
         (hl
          (jc-themes-colour-blend
           bg
           (jc-themes-colour-shade jc-themes-green-colour) 0.6))

         (bold '(:weight bold))
         (default '(:inherit default)))))


;;;###autoload
(when (and (boundp 'custom-theme-load-path) load-file-name)
  (let* ((base
          (file-name-directory (or load-file-name buffer-file-name)))
         (dir (expand-file-name base)))
    (add-to-list
     'custom-theme-load-path
     (or (and (file-directory-p dir) dir) base))))

(provide 'jc-themes)
;;; jc-themes.el ends here
