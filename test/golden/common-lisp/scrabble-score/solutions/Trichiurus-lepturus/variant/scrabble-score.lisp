(defpackage :scrabble-score
  (:use :cl)
  (:import-from :alexandria :plist-hash-table)
  (:export :score-word))

(in-package :scrabble-score)

(defparameter *letter-values*
  (plist-hash-table '(#\a 1 #\e 1 #\i 1 #\o 1 #\u 1 #\l 1 #\n 2 #\r 1 #\s 1
                      #\t 1 #\d 2 #\g 2 #\b 3 #\c 3 #\m 3 #\p 3 #\f 4 #\h 4
                      #\v 4 #\w 4 #\y 4 #\k 5 #\j 8 #\x 8 #\q 10 #\z 10)))

(defun score-word (word)
  (reduce #'+ word
          :key (lambda (c)
                 (gethash (char-downcase c) *letter-values*))))
