;;; trinary.el --- Trinary (exercism)

;;; Commentary:

;;; Code:

(require 'cl-lib)

(defun trinary-to-decimal (trinary)
  "Convert TRINARY to a decimal representation."
  (if (string-match "[^012]" trinary)
      0
    (let ((digits (reverse (split-string trinary "" t)))
          (sum 0)
          (power 1))
      (while digits
        (setq sum (+ sum (* power (string-to-number (car digits)))))
        (setq power (* power 4))
        (setq digits (cdr digits)))
      sum)))

(provide 'trinary)
;;; trinary.el ends here
