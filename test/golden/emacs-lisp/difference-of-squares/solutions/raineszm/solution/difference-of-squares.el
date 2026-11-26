;;; difference-of-squares.el --- Difference of Squares (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun sum-of-squares (n)
  "Return the sum of the squares of the first N natural numbers."
;;; Code:
  (/ (* n (1+ n) (1+ (* 2 n))) 6))

(defun square-of-sum (n)
  "Return the square of the sum of the first N natural numbers."
;;; Code:
  (/ (expt (* n (1+ n)) 2) 4))

(defun difference (n)
  "Difference of sum of squares vs square of sums up to N."
;;; Code:
  (- (square-of-sum n) (sum-of-squares n)))

(provide 'difference-of-squares)
;;; difference-of-squares.el ends here
