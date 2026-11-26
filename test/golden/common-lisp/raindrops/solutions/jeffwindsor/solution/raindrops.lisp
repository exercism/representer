(defpackage :raindrops
  (:use :cl)
  (:export :convert))

(in-package :raindrops)

(defun convert (number)
  (let ((result ""))
    (when (zerop (mod number 3))
      (setf result (concatenate 'string result "Pling")))
    (when (zerop (mod number 5))
      (setf result (concatenate 'string result "Plang")))
    (when (zerop (mod number 7))
      (setf result (concatenate 'string result "Plong")))
    (if (string= result "")
        (write-to-string number)
        result)))
