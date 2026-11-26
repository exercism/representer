;;; roman-numerals.el --- roman-numerals Exercise (exercism)

;;; Commentary:

;;; Code:

(defun to-roman (n)
  (cond ((< n 1) "")

        ((< n 4) (concat "I" (to-roman (- n 1))))
        ((< n 5) (concat "I" (to-roman (+ n 1))))
        ((< n 9) (concat "V" (to-roman (- n 5))))
        ((< n 10) (concat "I" (to-roman (+ n 1))))

        ((< n 40) (concat "X" (to-roman (- n 10))))
        ((< n 50) (concat "X" (to-roman (+ n 10))))
        ((< n 90) (concat "L" (to-roman (- n 50))))
        ((< n 100) (concat "X" (to-roman (+ n 11))))

        ((< n 400) (concat "C" (to-roman (- n 100))))
        ((< n 500) (concat "C" (to-roman (+ n 100))))
        ((< n 900) (concat "D" (to-roman (- n 500))))
        ((< n 1000) (concat "C" (to-roman (+ n 100))))

        (t (concat "M" (to-roman (- n 1000))))))

(provide 'roman-numerals)
;;; roman-numerals.el ends here
