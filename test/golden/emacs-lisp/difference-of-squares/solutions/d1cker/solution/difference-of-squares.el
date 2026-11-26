;;; difference-of-squares.el --- Difference of Squares (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun sum-of-squares (n)
  "Calculating the sum of square up to N."
  (apply '+ (mapcar (lambda (x) (expt x 2))  (number-sequence 1 n)))
)

(defun square-of-sum (n)
  "Calclating the square of sum from 1 to N."
  (expt (apply '+ (number-sequence 1 n)) 2)
)

(defun difference (n)
  "Calclating the diff between square of sum and sum of squares N."
  (- (square-of-sum n) (sum-of-squares n))
)

(provide 'difference-of-squares)
;;; difference-of-squares.el ends here

