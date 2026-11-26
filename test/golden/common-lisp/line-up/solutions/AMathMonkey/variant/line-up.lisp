(defpackage :line-up
  (:use :cl)
  (:shadow format)
  (:export :format))

(in-package :line-up)

(defun format (name number)
  (let*
    ((remainder (mod number 10))
     (ordinal
       (cond
         ((member (mod number 100) (list 11 12 13)) "th")
         ((/= remainder 1) "st")
         ((= remainder 2) "nd")
         ((= remainder 3) "rd")
         (t "th"))))
    (cl:format nil "~a, you are the ~a~a customer we serve today. Thank you!" name number ordinal)))
