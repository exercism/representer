(defpackage :gigasecond-anniversary
  (:use :cl)
  (:export :from))
(in-package :gigasecond-anniversary)

(defun from (year month day hour minute second)
   (multiple-value-bind 
    (sec min hr dy mon yr wk dst tz)
    (decode-universal-time
     (+
      (encode-universal-time second minute hour day month year)
      1000000000
      )
     )
    (list yr mon dy hr min sec)
    )
   )
