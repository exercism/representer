;;; roman-numerals.el --- roman-numerals Exercise (exercism)

;;; Commentary:
;;; I = 1, V = 5, X = 10, L = 50, C = 100, D = 500, M = 1000
;;; small before big => subtraction, small after big => addition

;;; Code:
(require 'cl)
(defun to-roman (number)
  (let ((roman-alist '((1000 . "M") (900 . "CM") (500 . "D")
                       (400 . "CD") (100 . "C") (90 . "XC") (50 . "L")
                       (40 . "XL") (10 . "X") (9 . "IX") (5 . "V") (4 . "IV") (1 . "I"))))
    (loop with roman-numeral = "" for (decimal . numeral) in roman-alist do
          (loop while (<= decimal number) do
                (setq roman-numeral (concat roman-numeral numeral))
                (decf number decimal))
          finally (return roman-numeral))))

(provide 'roman-numerals)
;;; roman-numerals.el ends here
