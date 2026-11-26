(defpackage :collatz-conjecture
  (:use :cl)
  (:export :collatz))

(in-package :collatz-conjecture)

(defun collatz (n) 
  (cond 
    ((<= n 0) nil)
    (t
     (do
      ((result 0 (+ result 1)))
      ((= n 1) result)
      (cond 
        ((evenp n) (setq n (/ n 2)))
        ((oddp n) (setq n (+ 1 (* n 3)))))))))