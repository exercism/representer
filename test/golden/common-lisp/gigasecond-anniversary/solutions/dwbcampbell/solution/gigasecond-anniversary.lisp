(defpackage :gigasecond-anniversary
  (:use :cl)
  (:export :from))
(in-package :gigasecond-anniversary)

(defun from (year month day hour minute second)
  (multiple-value-bind (second2 minute2 hour2 day2 month2 year2) 
      (decode-universal-time
       (+ 1000000000
          (encode-universal-time second minute hour day month year 0)))
    (list year2 month2 day2 hour2 minute2 second2)))

