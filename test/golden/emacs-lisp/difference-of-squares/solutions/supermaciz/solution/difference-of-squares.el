;;; difference-of-squares.el --- Difference of Squares (exercism)

;;; Commentary:

;;; Code:
(defun square (x) (* x x))

(defun square-of-sum (x)
  (square (apply '+ (number-sequence 1 x))))

(defun sum-of-squares (x)
  (apply '+
         (mapcar 'square (number-sequence 1 x))))

(defun difference (x)
  (- (square-of-sum x) (sum-of-squares x)))

(provide 'difference-of-squares)
;;; difference-of-squares.el ends here
