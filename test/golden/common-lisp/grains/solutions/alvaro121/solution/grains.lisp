(in-package #:cl-user)
(defpackage #:grains
  (:use #:cl)
  (:export :square :total))
(in-package #:grains)

(defun square (n)
  (expt 2
        (1- n)))

(defun total ()
  (let ((ret 0))
    (dotimes (i 64 ret)
      (incf ret
            (square (1+ i))))))
