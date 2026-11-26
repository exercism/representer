(defpackage :character-study
  (:use :cl)
  (:export
   :compare-chars
   :size-of-char
   :change-size-of-char
   :type-of-char))
(in-package :character-study)

(defun compare-chars (char1 char2)
  (cond ((char> char1 char2) :greater-than)
        ((char< char1 char2) :less-than)
        ((char= char1 char2) :equal-to)))
;; (compare-chars #\a #\b)

(defun size-of-char (char)
  (cond ((upper-case-p char) :big)
        ((lower-case-p char) :small)
        (t :no-size)))
;; (size-of-char #\0)

(defun change-size-of-char (char wanted-size)
  (case wanted-size
    (:big (char-upcase char))
    (:small (char-downcase char))))
;; (change-size-of-char #\a :big)
;; (change-size-of-char #\A :small)

(defun type-of-char (char)
  (cond ((alpha-char-p char) :alpha)
        ((digit-char-p char) :numeric)
        ((char= char #\Space) :space)
        ((char= char #\Newline) :newline)
        (t :unknown)))
;; (type-of-char #\a)
;; (type-of-char #\3)
;; (type-of-char #\Space)
;; (type-of-char #\Newline)
;; (type-of-char #\@)
