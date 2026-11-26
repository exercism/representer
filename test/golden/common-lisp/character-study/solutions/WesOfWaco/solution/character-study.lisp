(defpackage :character-study
  (:use :cl)
  (:export
   :compare-chars
   :size-of-char
   :change-size-of-char
   :type-of-char))
(in-package :character-study)

(defun compare-chars (char1 char2)
  "Compare CHAR1 and CHAR2. Produce :greater-than if CHAR1 is greater than CHAR2, :less-than if CHAR1 is less than CHAR2, :euqal-to otherwise."
  (cond ((char> char1 char2) :greater-than)
	((char< char1 char2) :less-than)
	(t :equal-to)))

(defun size-of-char (char)
  "Given a char, produce :big if uppercase, :small if lowercase, and :no-size if non-alpha."
  (cond
    ((char= (char-downcase char) (char-upcase char)) :no-size)
    ((char= char (char-upcase char)) :big)
    ((char= char (char-downcase char)) :small)))

(defun change-size-of-char (char wanted-size)
  "Given a character and a desired size, produce a character of that size."
  (case wanted-size
    (:big (char-upcase char))
    (:small (char-downcase char))))

(defun type-of-char (char)
  "Produce class of character."
  (cond ((alpha-char-p char) :alpha)
	((digit-char-p char) :numeric)
	((string= (char-name char) "Space") :space)
	((string= (char-name char) "Newline") :newline)
	(t :unknown)))
