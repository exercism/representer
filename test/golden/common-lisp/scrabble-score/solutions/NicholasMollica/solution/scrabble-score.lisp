(defpackage :scrabble-score
  (:use :cl)
  (:export :score-word))

(in-package :scrabble-score)

(defun letter-values (letter) "Gets the value of each letter"   
  (case(char-upcase letter)
    ((#\A #\E #\I #\O #\U #\L #\N #\R #\S #\T) 1)
    ((#\D #\G) 2)
    ((#\B #\C #\M #\P) 3)
    ((#\F #\H #\V #\W #\Y) 4)
    ((#\K) 5)
    ((#\J #\X) 8)
    ((#\Q #\Z) 10)
    (otherwise 0)))

(defun score-word (word)
  "Computes the score for an entire word."
(loop for v across word
      sum (letter-values v)))