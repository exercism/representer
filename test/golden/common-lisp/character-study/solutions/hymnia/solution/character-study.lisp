(defpackage :character-study
  (:use :cl)
  (:export
   :compare-chars
   :size-of-char
   :change-size-of-char
   :type-of-char))
(in-package :character-study)

(defun compare-chars (char1 char2)
  "Compare two characters, determining if the first is greater-than,
less-than or equal-to the second."
  (cond ((char> char1 char2) :greater-than)
        ((char< char1 char2) :less-than)
        ((char= char1 char2) :equal-to)))

(defun size-of-char (char)
  "Determine if a character is \"big\" (a uppercase character) or
\"little\" (a lowercase character), or \"no-size\" if it is neither."
  (cond ((upper-case-p char) :big)
        ((lower-case-p char) :small)
        (:no-size)))

(defun change-size-of-char (char wanted-size)
  "Return the corresponding character with the correct size."
  (case wanted-size
    (:big (char-upcase char))
    (:small (char-downcase char))
    (otherwise char)))

(defun type-of-char (char)
  "Return :alpha if the character is an alphabetic character, :numeric if it is a numeric character, :space if it is a space character, :newline if it is a newline character and :unknown otherwise."
  (cond ((alpha-char-p char) :alpha)
        ((digit-char-p char) :numeric)
        ((char-equal char #\Space) :space)
        ((char-equal char #\Newline) :newline)
        (:unknown)))
