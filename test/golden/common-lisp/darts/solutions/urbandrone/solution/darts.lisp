(defpackage :darts
  (:use :cl)
  (:export :score))

(in-package :darts)

(defun in-circle-p (x y r)
  (<= (+ (* x x) (* y y))
      (* r r)))

(defun score (x y)
  (cond ((in-circle-p x y 1) 10)
        ((in-circle-p x y 5) 5)
        ((in-circle-p x y 10) 1)
        (t 0)))
