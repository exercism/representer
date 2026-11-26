(defpackage :collatz-conjecture
  (:use :cl)
  (:export :collatz))

(in-package :collatz-conjecture)

(defun collatz (n)
  (unless (< n 1)
    (do ((n n (if (evenp n)
                  (* n 2)
                  (+ 1 (* 3 n)))) 
         (steps 0 (+ 1 steps)))
        ((<= n 1) steps))))
