(defpackage :square-root
  (:use :cl)
  (:export :square-root))

(in-package :square-root)

(defun square-root (n)
  "Integer square root using ascending linear search."
  (do ((q (if (evenp n) 2 1) (+ q 2)))
      ((>= (* q q) (1- n)) q)))