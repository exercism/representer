(defpackage :leap
  (:use :cl)
  (:export :leap-year-p))
(in-package :leap)

(defun leap-year-p (year)
  (cond ((divisible-by year 400) t)
        ((divisible-by year 100) nil)
        ((divisible-by year 4) t)))

(defun divisible-by (year num)
  (zerop (rem year num)))
