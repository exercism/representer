(defpackage :pascals-triangle
  (:use :cl)
  (:export :rows))
(in-package :pascals-triangle)

(defun next-row (row)
  (if (not row)
      '(1)
      `(1
        ,@(loop for (a b) on row by #'cdr while b
                collect (+ a b))
        1)))

(defun rows (n)
  (when (>= n 0)
    (loop with row = ()
          with ret = ()
          for i from 1 to n
          do (progn (setf row (next-row row))
                    (push row ret))
          finally (return (nreverse ret)))))

