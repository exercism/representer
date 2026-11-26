(defpackage :gigasecond-anniversary
  (:use :cl)
  (:export :from))
(in-package :gigasecond-anniversary)

(defun from (year month day hour minute second)
  (let ((given-universal-time
	  (encode-universal-time second minute hour day month year 0)))
    (multiple-value-bind (sec min hr d m y)
	(decode-universal-time
	 (+ given-universal-time
	    1000000000) 0)
      (list y m d hr min sec))))
    
