(defpackage :gigasecond-anniversary
  (:use :cl)
  (:export :from))
(in-package :gigasecond-anniversary)

;; encode-universal-time second minute hour date month year &optional time-zone
;; => universal-time

;; decode-universal-time universal-time &optional time-zone
;; => second, minute, hour, date, month, year, day, daylight-p, zone

(defun from (year month day-of-month hour minute second)
  (let* ((universal-time (encode-universal-time second minute hour day-of-month month year 0))
           (future-time (+ 1000000000 universal-time)))
       (multiple-value-bind
         (_second _minute _hour _day-of-month _month _year _day-of-week _daylight-p _zone)
         (decode-universal-time future-time)
         (list _year _month _day-of-month _hour _minute _second))))
