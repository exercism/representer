;;; collatz-conjecture.el --- Collatz Conjecture (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun steps (number)
  "Count number of iterations to reach 1 starting at NUMBER."
  (when (<= number 0) (error "Number must be positive"))
  (let ((steps 0))
    (while (not (eq number 1))
      (setq steps (1+ steps))
      (if (eq 0 (mod number 2))
          (setq number (/ number 2))
        (setq number (+ (* 3 number) 1))))
    steps))

(provide 'collatz-conjecture)
;;; collatz-conjecture.el ends here
