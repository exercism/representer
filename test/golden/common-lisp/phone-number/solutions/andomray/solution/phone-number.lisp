(defpackage :phone-number
  (:use :cl)
  (:export :clean))

(in-package :phone-number)

(defparameter +error-code+ "0000000000")

(defun error-check (numlist)
  (cond
    ((< (length numlist) 10) +error-code+)
    ((and (> (length numlist) 10) (char/= #\1 (first numlist))) +error-code+)
    ((char< (first numlist) #\2) +error-code+)
    ((char< (fourth numlist) #\2) +error-code+)
    (t (format nil "~{~a~}" numlist))))

(defun clean (phrase)
  "Converts a PHRASE string into a string of digits.
Will evaluate to \"0000000000\" in case of an invalid input."
  (let ((clean-num (loop for c across phrase
                         when (digit-char-p c)
                           collect c)))
  (if (and (= 11 (length clean-num))
           (char= #\1 (first clean-num)))
      (error-check (rest clean-num))
      (error-check clean-num))))
