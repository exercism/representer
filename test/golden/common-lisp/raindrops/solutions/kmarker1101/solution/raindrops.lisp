(defpackage :raindrops
  (:use :cl)
  (:export :convert))

(in-package :raindrops)


(defun convert (num)
  (let ((result ""))
    (when (zerop (mod num 3))
      (setf result (concatenate 'string result "Pling")))
    (when (zerop (mod num 5))
      (setf result (concatenate 'string result "Plang")))
    (when (zerop (mod num 7))
      (setf result (concatenate 'string result "Plong")))
    (if (string= result "")
        (write-to-string num)
        result)))
