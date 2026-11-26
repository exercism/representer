;;; difference-of-squares.el --- Difference of Squares (exercism)

;;; Commentary:

;;; Code:


(provide 'difference-of-squares)
;;; difference-of-squares.el ends here

(defun square (num)
	(* num num))

(defun square-of-sum (num)
	(square (apply '+ (number-sequence 1 num))))

(defun sum-of-squares (num)
	(apply '+ (mapcar 'square (number-sequence 1 num))))

(defun difference (num)
	(- (square-of-sum num) (sum-of-squares num)))
