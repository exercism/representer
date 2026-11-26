;;; difference-of-squares.el --- Difference of Squares (exercism)

;;; Commentary:

;;; Code:

(defun square-of-sum (x)
  (let ((sum 0)
        (a 1))
    (dotimes (i x sum)
      (setq sum (+ sum a)
            a (+ a 1)))
    (* sum sum)))

(defun sum-of-squares (x)
  (let ((sum 0)
        (a 1))
    (dotimes (i x sum)
      (setq sum (+ sum (* a a))
            a (+ a 1)))))

(defun difference (x)
  (- (square-of-sum x) (sum-of-squares x)))

(provide 'difference-of-squares)
;;; difference-of-squares.el ends here
