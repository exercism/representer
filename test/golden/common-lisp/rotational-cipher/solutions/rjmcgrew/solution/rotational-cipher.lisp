(defpackage :rotational-cipher
  (:use :cl)
  (:export :rotate))

(in-package :rotational-cipher)

(defun rotate (text key)
  (map 'string #'(lambda (c) (rotate-char c key)) text))

(defun rotate-char (c shift-key)
  (cond ((lower-case-p c) (rotate-char-case c shift-key #\a))
        ((upper-case-p c) (rotate-char-case c shift-key #\A))
        (t c)))

(defun rotate-char-case (c shift-key base-character)
  (code-char
   (+ (char-code base-character)
      (mod (+
            shift-key
            (- (char-code c)
               (char-code base-character)))
           26))))


