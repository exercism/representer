;;; difference-of-squares.el --- Difference of Squares (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun sum-of-squares (n)
  "Return the sum of squares of integers from 1 up to N."
;;; Code:
  (/ (* n
	(1+ n)
	(1+ (* 2 n)))
     6)
  )

(defun square-of-sum (n)
  "Return square of sum of integers from 1 up to N."
;;; Code:
  (/ (* (expt n 2) (expt (1+ n) 2)) 4)
  )

(defun difference (n)
  "Return (square of sum of first N integers)
- (sum of squares of first N integers)."
;;; Code:
  (- (square-of-sum n) (sum-of-squares n))
  )


(provide 'difference-of-squares)
;;; difference-of-squares.el ends here
