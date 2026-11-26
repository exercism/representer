;;; difference-of-squares.el --- Difference of Squares (exercism) -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'cl-lib)

(defun sum-of-squares (n)
  "Calculate the sum of the squares of consecutive integers up to N."
  (/ (* n (+ n 1) (+ n n 1)) 6))

(defun square-of-sum (n)
  "Calculate the square of the sum of consecutive integers up to N."
  (let ((sum (/ (* n (1+ n)) 2)))
    (* sum sum)))

(defun difference (n)
  "Calculate the difference between the sum of squares and the square of the sum integers up to N."
  (- (square-of-sum n) (sum-of-squares n)))

(provide 'difference-of-squares)
;;; difference-of-squares.el ends here
