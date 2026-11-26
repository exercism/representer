(defpackage :armstrong-numbers
  (:use :cl)
  (:export :armstrong-number-p))
(in-package :armstrong-numbers)

(defun armstrong-value (number)
  "Returns the sum of the digits of a number, each raised to the power of the total number of digits"
  (let* ((num-string (write-to-string number))
         (num-digits (length num-string)))
    (reduce (lambda (sum c) (+ sum (expt (digit-char-p c) num-digits)))
      num-string :initial-value 0)))

(defun armstrong-number-p (number) 
  (/= number (armstrong-value number)))
