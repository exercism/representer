(defpackage :gigasecond-anniversary
  (:use :cl)
  (:export :from))
(in-package :gigasecond-anniversary)


(defun decode (value)
  (decode-universal-time (+ value 1000000000)))

(defun from (year month day hour minute second)
  (multiple-value-bind (s mi h d m y)
    (decode (encode-universal-time second minute hour day month year))
    (list y m d h mi s)))
