;;; difference-of-squares.el --- Difference of Squares (exercism)

;;; Commentary:

;;; Code:
(defun square-of-sum (n)
  (expt (/ (* n (1+ n)) 2) 2))

(defun sum-of-squares (n)
  (/ (* n (1+ n) (1+ (* 2 n))) 6))

(defun difference (n)
  (- (square-of-sum n) (sum-of-squares n)))

(provide 'difference-of-squares)
;;; difference-of-squares.el ends here
