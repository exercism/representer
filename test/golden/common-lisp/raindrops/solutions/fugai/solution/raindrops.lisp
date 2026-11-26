(defpackage :raindrops
  (:use :cl)
  (:export :convert))

(in-package :raindrops)

(defun convert (number)
  (let ((result ""))
    (if (zerop (mod number 3))
        (setf result (concatenate 'string result "Pling")))
    (if (zerop (mod number 5))
        (setf result (concatenate 'string result "Plang")))
    (if (zerop (mod number 7))
        (setf result (concatenate 'string result "Plong")))
    (if (string= result "")
        (setf result (write-to-string number)))
    result)
  )
