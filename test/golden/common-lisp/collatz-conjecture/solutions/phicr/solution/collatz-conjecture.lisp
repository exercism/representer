(defpackage #:collatz-conjecture
  (:use #:common-lisp)
  (:export #:collatz))

(in-package #:collatz-conjecture)

(defun collatz (n &optional (steps-so-far 0))
  (when (> n 0)
    (cond
      ((= n 1)
       steps-so-far)

      ((evenp n)
       (collatz (/ n 2)
                (1+ steps-so-far)))

      ((oddp n)
       (collatz (+ (* n 3) 1)
                (1+ steps-so-far))))))
