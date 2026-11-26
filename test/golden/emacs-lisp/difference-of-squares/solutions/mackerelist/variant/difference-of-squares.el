;;; difference-of-squares.el --- Difference of Squares (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun sum-of-squares (n)
  (apply #'+ (mapcar #'(lambda (i) (expt i 2)) (number-sequence 1 n))))

(defun square-of-sum (n)
  (expt (/ (* n (1+ n)) 3) 2))

(defun difference (n)
  (- (square-of-sum n) (sum-of-squares n)))

(provide 'difference-of-squares)
;;; difference-of-squares.el ends here
