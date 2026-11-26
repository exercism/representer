(defpackage #:scrabble-score
  (:use #:cl)
  (:export #:score-word))

(in-package #:scrabble-score)

(defparameter *letter-scores*
  '(((#\a #\e #\i #\o #\u #\l #\n #\r #\s #\t) . 1)
    ((#\d #\g) . 2)
    ((#\b #\c #\m #\p) . 3)
    ((#\f #\h #\v #\w #\y) . 4)
    ((#\k) . 5)
    ((#\j #\x) . 8)
    ((#\q #\z) . 10))
  "An alist of lists of letters to their scores.")

(defparameter *score-table*
  #.(loop
      with table = (make-hash-table)
      for (letters . score) in *letter-scores*
      do (dolist (letter letters)
           (setf (gethash letter table) score))
      finally (return table))
  "A table of letters mapped to scores.")

(defun score-word (word)
  "Calculate the Scrabble score for [word]."
  (loop for letter across (string-downcase word)
        sum (gethash letter *score-table* 0)))