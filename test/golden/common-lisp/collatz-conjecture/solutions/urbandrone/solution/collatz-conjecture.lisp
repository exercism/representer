(defpackage :collatz-conjecture
  (:use :cl)
  (:export :collatz))

(in-package :collatz-conjecture)

(defun collatz-rec (steps n)
  (cond ((<= n 0) nil)
        ((<= n 1) steps)
        ((oddp n) (collatz-rec (+ steps 1) (+ 1 (* n 3))))
        (t (collatz-rec (+ steps 1) (/ n 2)))))

(defun collatz (n)
  (cond ((not (numberp n)) n)
        (t (collatz-rec 0 n))))
