;;; perfect-numbers.el --- perfect-numbers Exercise (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun aliquot-sum (number)
  "Return the sum of the factors of `number'.
Include 1 and exclude `number'."
  (1+ (cl-loop for i from 2 to (cl-isqrt number)
               if (= 0 (% number i))
                 sum (if (= i (/ number i))
                         i
                       (+ i (/ number i))))))

(defun classify (number)
  (if (<= number 0)
      (error "Classification is only possible for natural numbers")
    (let ((asum (aliquot-sum number)))
      (cond ((= 2 asum)      'deficient)
            ((< number asum) 'abundant)
            ((> number asum) 'deficient)
            (t               'perfect)))))

(provide 'perfect-numbers)
;;; perfect-numbers.el ends here
