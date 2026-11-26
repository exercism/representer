(defpackage :gigasecond-anniversary
  (:use :cl)
  (:export :from))
(in-package :gigasecond-anniversary)

(defun from (year month day hour minute second)
  (let ((unixtime (encode-universal-time second minute hour day month year 0)))
    (multiple-value-bind (sec min h d m y) (decode-universal-time (+ unixtime 1000000000))
      (list y m d h min sec))))