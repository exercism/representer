(defpackage :pythagorean-triplet
  (:use :cl)
  (:export :triplets-with-sum))

(in-package :pythagorean-triplet)

(defun triplets-with-sum (n)
  (labels ((square (n) (* n n))
	   (tripletp (a b c)
	     (= (square c) (- (square a) (square b)))))
    (loop
      for a from 1 to (truncate n 3)
      append
      (loop for b from (1+ a) to (truncate (- n a) 2)
	    for c = (- n a b)
	    if (tripletp a b c)
	      collect (list a b c)))))
