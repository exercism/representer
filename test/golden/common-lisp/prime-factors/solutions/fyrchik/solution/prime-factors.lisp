(defpackage :prime-factors
  (:use :cl)
  (:export :factors))

(in-package :prime-factors)

(defun factors (n)
  (let ((x n) result)
       (loop for p = 2
          then (if (zerop (mod x p))
                   (progn
                     (setf result (cons p result))
                     (setf x (/ x p))
                     p)
                   (1+ p))
          until (= 1 x))
       (nreverse result)))