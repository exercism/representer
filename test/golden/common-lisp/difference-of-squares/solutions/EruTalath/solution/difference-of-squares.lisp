(defpackage :difference-of-squares
  (:use :cl)
  (:export :sum-of-squares
           :square-of-sum
           :difference))

(in-package :difference-of-squares)

(defun square-of-sum (n)
  (expt (floor (* n (+ n 1)) 2) 2)
  )

(defun sum-of-squares (n)
  (floor (* n (+ n 1) (+ n n 1)) 6)
  )

(defun difference (n)
  (- (square-of-sum n) (sum-of-squares n))
  )
