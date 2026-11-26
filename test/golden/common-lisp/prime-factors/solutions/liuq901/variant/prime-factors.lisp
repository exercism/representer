(defpackage :prime-factors
  (:use :cl)
  (:export :factors))

(in-package :prime-factors)

(defun find-factor (x n)
  (cond
    ((>= (* x x) n) n)
    ((= 0 (mod n x)) x)
    (t (find-factor (1+ x) n))))

(defun factors (n)
  (if (= 1 n)
      ()
      (let ((factor (find-factor 2 n)))
           (cons factor (factors (/ n factor))))))
