;;; accumulate.el --- Accumulate (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun accumulate (lst op)
  "Run method OP over each item in LST."
  (mapcar op lst))

(provide 'accumulate)
;;; accumulate.el ends here
