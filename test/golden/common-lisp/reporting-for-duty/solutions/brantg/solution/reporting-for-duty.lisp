(defpackage :reporting-for-duty
  (:use :cl)
  (:export :format-quarter-value :format-two-quarters
           :format-two-quarters-for-reading))

(in-package :reporting-for-duty)

;; Define format-quarter-value function.
(defun format-quarter-value (quarter value)
  (format nil "The value ~a quarter: ~a" quarter value))

;; Define format-two-quarters function.
(defun format-two-quarters (stream quarter1 value1 quarter2 value2)
  (format stream "~%~a~%~a~%" (format-quarter-value quarter1 value1)
          (format-quarter-value quarter2 value2)))

;; Define format-two-quarters-for-reading function.
(defun format-two-quarters-for-reading (stream quarter1 value1 quarter2 value2)
  (format stream "~s" (list
                          (format-quarter-value quarter1 value1)
                          (format-quarter-value quarter2 value2))))
