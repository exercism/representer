;;; difference-of-squares.el --- Difference of Squares (exercism)

;;; Commentary:

;;; Code:

(defun sum-of-sequence (n)
  (if (= n 1)
      1
    (* (+ 1 n)
       (/ n 2.0))))

(defun square-of-sum (n)
  (let ((sum (sum-of-sequence n)))
    (* sum sum)))

(defun sum-of-squares (n)
  (if (= 1 n)
      1
    (+ (* n n)
       (sum-of-squares (- n 1)))))

(defun difference (n)
  (- (square-of-sum n)
     (sum-of-squares n)))

(provide 'difference-of-squares)
;;; difference-of-squares.el ends here
