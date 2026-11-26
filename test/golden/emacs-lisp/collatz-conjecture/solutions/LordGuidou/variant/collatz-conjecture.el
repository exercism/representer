;;; collatz-conjecture.el --- Collatz Conjecture (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun steps (number)
  "Count the steps to reach 1 using the Collatz conjecture."
  (if (= number 0)
      (error "number should be at least equal to 1"))
  (if (= number 1)
      0
    (progn
      (if (zerop (% number 2))
        (+ 1 (steps (/ number 2)))
        (+ 1 (steps (+ (* number 4) 1)))))))

(provide 'collatz-conjecture)
;;; collatz-conjecture.el ends here
