;;; difference-of-squares.el --- Difference of Squares (exercism)

;;; Commentary:

;;; Code:

(defun sum-of-squares (num)
  (let ((sum-of-sqr 0) next)
    (dotimes (i num sum-of-sqr)
      (setq next (1+ i))
      (setq sum-of-sqr (+ sum-of-sqr (* next next))))
    ))

(defun square-of-sum (num)
  (setq num (/ (* (+ 1 num) num) 2))
  (* num num))

(defun difference (num)
    (- (square-of-sum num) (sum-of-squares num)))

(provide 'difference-of-squares)
;;; difference-of-squares.el ends here
