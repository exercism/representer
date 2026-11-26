;;; difference.el --- Difference of Squares (exercism)

;;; Commentary:

;;; Code:

(defun sum-of-squares (n &optional sum)
  (if (= n 0) sum
    (sum-of-squares (- n 1) (+ (or sum 0) (* n n)))))

(defun square-of-sum (n &optional sum)
  (if (= n 0) (* sum sum)
    (square-of-sum (- n 1) (+ (or sum 0) n))))

(defun difference (n)
  (- (square-of-sum n) (sum-of-squares n)))

(provide 'difference)
;;; difference.el ends here
