(defmodule difference-of-squares
  (export (square-of-sum 1)
          (sum-of-squares 1)
          (difference-of-squares 1)))

(defun square-of-sum (x)
  (let ((sum (div (* x (+ x 1)) 2)))
    (* sum sum)))

(defun sum-of-squares (x)
  (div (* x (+ x 1) (+ (* x 2) 1)) 6))

(defun difference-of-squares (x)
  (- (square-of-sum x) (sum-of-squares x)))
