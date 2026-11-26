;;; square-root.el --- Square Root (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun square-root (radicand)
  "Compute the square root of RADICAND.
This function uses the Newton-Raphson method to approximate the square root."
  (if (< radicand 0)
      (error "Square root of a negative number is undefined")
    (let ((x (/ radicand 2.0)) ; Initial guess for the square root
          (epsilon 0.00001)) ; Tolerance for the approximation
      (while (> (abs (- (* x x) radicand)) epsilon) ; Check if the difference between x^2 and radicand is greater than epsilon
        (setq x (/ (+ x (/ radicand x)) 2.0))) ; Update x using the Newton-Raphson formula: f(x) = (x + radicand/x) / 2
      (truncate x)))) ; Return the truncated value of x



(provide 'square-root)
;;; square-root.el ends here
