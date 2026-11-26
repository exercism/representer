(defpackage :scrabble-score
  (:use :cl)
  (:export :score-word))

(in-package :scrabble-score)

(defparameter *letter-score*
  #.(loop
      with table = (make-hash-table)
      for (letters score)
        on '(aeioulnrst 1 dg 2 bcmp 3 fhvwy 4 k 5 jx 8 qz 10)
        by #'cddr
      do (loop for letter across (symbol-name letters)
               do (setf (gethash letter table) score))
      finally (return table)))

(defun score-letter (letter)
  (gethash (char-upcase letter) *letter-score* 0))



(defun score-word (word)
  "Computes the score for an entire word."
  (reduce #'+ (map 'list #'score-letter word)))
