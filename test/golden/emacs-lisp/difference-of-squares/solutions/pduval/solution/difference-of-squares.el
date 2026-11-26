;;; difference-of-squares.el --- Difference of Squares (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:
(defun square (n) (* n n))

(defun sum-of-squares (n)
;;; Code:
  (if (> n 0)
    (+ (* n n) (sum-of-squares (- n 1)))
   0)
)

(defun square-of-sum (n)
;;; Code:
  (if (> n 0)
    (square (/ (* n (+ n 1)) 2) )
      0
  )
)

(defun difference (n)
;;; Code:
  (- (square-of-sum n) (sum-of-squares n))
)

(provide 'difference-of-squares)
;;; difference-of-squares.el ends here
