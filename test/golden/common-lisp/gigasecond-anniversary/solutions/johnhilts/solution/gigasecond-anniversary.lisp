(defpackage :gigasecond-anniversary
  (:use :cl)
  (:export :from))

(in-package :gigasecond-anniversary)

(defun from (year month day hour minute second)
  "Takes 6 parameters: `year`, `month`, `day`, `hour`, `min`, `sec` and computes the date and time of the Gigasecond anniversary.
This function returns the date as a list of the same order and meaning as the parameters of the input.
Gigasecond: 1,000,000,000 seconds since the event."
  (let* ((time-zone 0)
         (utc (encode-universal-time second minute hour day month year time-zone))
         (utc+gigasecond (+ utc (expt 10 9))))
    (multiple-value-bind
          (second minute hour day month year)
        (decode-universal-time utc+gigasecond time-zone)
      (list year month day hour minute second))))
