(defpackage :gigasecond-anniversary
  (:use :cl)
  (:export :from))
(in-package :gigasecond-anniversary)

(defun from (year month day hour minute second)
  (let ((d (encode-universal-time second minute hour day month year 0)))
    (multiple-value-bind (s m h d mon y dow dst tz)
	(decode-universal-time (+ d 1000000000) 0)
      (list y mon d h m s))))
		      
