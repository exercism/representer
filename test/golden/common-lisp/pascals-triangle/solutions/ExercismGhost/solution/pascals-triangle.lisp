(defpackage :pascals-triangle
  (:use :cl)
  (:export :rows))
(in-package :pascals-triangle)

(defun rows (n &optional (row-lst '(1)))
  (when (plusp n)
    (let ((new-row (cons 0 row-lst)))
         (cons row-lst (rows (1- n) (mapcar #'+ new-row (reverse new-row)))))))

