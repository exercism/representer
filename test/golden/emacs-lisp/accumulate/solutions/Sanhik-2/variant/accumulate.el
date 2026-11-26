;;; accumulate.el --- Accumulate (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(defun op (x)
  (* x x))

(defun accumulate (lst op)
  (cond
   ((null lst) nil)
   (t (cons (funcall op (car lst))
            (accumulate (car lst) op)))))

(provide 'accumulate)
;;; accumulate.el ends here
