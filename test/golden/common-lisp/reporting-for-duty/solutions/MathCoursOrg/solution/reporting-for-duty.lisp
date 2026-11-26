(defpackage :reporting-for-duty
  (:use :cl)
  (:export :format-quarter-value :format-two-quarters
           :format-two-quarters-for-reading))

(in-package :reporting-for-duty)

;; Define format-quarter-value function.
(defun format-quarter-value (word number)
  (format nil "The value ~a quarter: ~a"  word number))
;; Define format-two-quarters function.

(defun format-two-quarters (output w1 n1 w2 n2)
  (format output "~%~a~%~a~%" (format-quarter-value w1 n1) (format-quarter-value w2 n2)))
;; Define format-two-quarters-for-reading function.
(defun format-two-quarters-for-reading (output w1 n1 w2 n2)
  (format output "~s" (list (format-quarter-value w1 n1) (format-quarter-value w2 n2))))