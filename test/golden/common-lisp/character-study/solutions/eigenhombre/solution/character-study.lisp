(defpackage :character-study
  (:use :cl)
  (:export
   :compare-chars
   :size-of-char
   :change-size-of-char
   :type-of-char))
(in-package :character-study)

(defun compare-chars (char1 char2)
  (cond
    ((char< char1 char2) :less-than)
    ((char> char1 char2) :greater-than)
    ((char= char1 char2) :equal-to)
    (t (error "unexpected inequality"))))

(defun size-of-char (char)
  (cond
    ((and (char>= char #\A)
          (char<= char #\Z)) :big)
    ((and (char>= char #\a)
          (char<= char #\z)) :small)
    (t :no-size)))

(defun change-size-of-char (char wanted-size)
  (funcall (or (cdr (assoc wanted-size
                           '((:big . char-upcase)
                             (:small . char-downcase))))
               #'identity)
           char))

(defun type-of-char (char)
  (cond
    ((and (char>= char #\A)
          (char<= char #\Z)) :alpha)
    ((and (char>= char #\a)
          (char<= char #\z)) :alpha)
    ((and (char>= char #\0)
          (char<= char #\9)) :numeric)
    ((char= #\Newline char) :newline)
    ((char= #\Space char) :space)
    (t :unknown)))
