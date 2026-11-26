(defpackage :difference-of-squares
  (:use :cl)
  (:export :sum-of-squares
           :square-of-sum
           :difference))

(in-package :difference-of-squares)

(defun square-of-sum (n)
  "Calculates the square of the sum for a given number."
  (let ((s (/ (* n (+ n 1)) 2)))
    (* s s))
  )

(defun sum-of-squares (n)
  "Calculates the sum of squares for a given number."
  (/ (* n (+ n 1) (+ (* n 2) 1)) 6))

(defun difference (n)
  "Finds the diff. between the square of the sum and the sum of the squares."
  (- (square-of-sum n) (sum-of-squares n)))
