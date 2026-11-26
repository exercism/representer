(defpackage :darts
  (:use :cl)
  (:export :score))

(in-package :darts)

(defun score (x y)
  (let ((d (sqrt (+ (expt x 2)
                    (expt y 2)))))
       (cond
         ((> d 10) 0)
         ((and (< 5 d)
               (<= d 10)) 1)
         ((and (< 1 d)
               (<= d 5)) 5)
         ((<= d 1) 10))))