(defpackage :reporting-for-duty
  (:use :cl)
  (:export :format-quarter-value :format-two-quarters
           :format-two-quarters-for-reading))

(in-package :reporting-for-duty)

(setf *format-string* "The value ~a quarter: ~a")
;; Define format-quarter-value function.
(defun format-quarter-value (quarter value)
      (format nil *format-string* quarter value))

;; Define format-two-quarters function.
(defun format-two-quarters (stream qtr1 val1 qtr2 val2)
  (format stream "~%~a~%~a~&" 
          (format nil (format-quarter-value qtr1 val1))
          (format nil  (format-quarter-value qtr2 val2))))

;; Define format-two-quarters-for-reading function.
(defun format-two-quarters-for-reading (stream qtr1 val1 qtr2 val2)
  (format stream "\(~s ~s\)" 
          (format nil (format-quarter-value qtr1 val1))
          (format nil  (format-quarter-value qtr2 val2))))