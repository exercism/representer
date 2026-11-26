(defpackage :darts
  (:use :cl)
  (:export :score))

(in-package :darts)

(defun score (x y)
  (let ((radius (sqrt (+ (* x x) (* y y)))))
    (cond
      ((<= radius 1) 10)
      ((<= radius 5) 5)
      ((<= radius 10) 1)
      (t 0))))
