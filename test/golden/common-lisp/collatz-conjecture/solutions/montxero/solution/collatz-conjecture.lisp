(defpackage :collatz-conjecture
  (:use :cl)
  (:export :collatz))

(in-package :collatz-conjecture)

(defun collatz (n)
  (labels ((rec (x count)
             (cond ((= 1 x) count)
                   ((evenp x) (rec (/ x 2) (1+ count)))
                   (t (rec (1+ (* 3 x)) (1+ count))))))
    (when (plusp n)
      (rec n 0))))
