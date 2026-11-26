;;; difference-of-squares.el --- Difference of Squares (exercism)

;;; Commentary:

;;; Code:


(provide 'difference-of-squares)

(defun difference (n)
  (- (square-of-sum n) (sum-of-squares n)))

(defun sum-of-squares (n)
  ;;; n * (n + 1) * (n * 2 + 1) / 6
  (/ (* n (* (+ n 1) (+ (* n 2) 1))) 6))

(defun square-of-sum (n)
  ;;; (n * (n +1) / 2)^2
  (expt (/ (* n (+ n 1)) 2) 2))
;;; difference-of-squares.el ends here
