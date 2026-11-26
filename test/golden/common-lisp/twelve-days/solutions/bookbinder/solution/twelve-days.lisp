(defpackage :twelve-days
  (:use :cl)
  (:export :recite))

(in-package :twelve-days)
(defparameter days
    '("twelfth" "eleventh" "tenth" "ninth" "eighth" "seventh" "sixth"
      "fifth" "fourth" "third" "second" "first"))

(defparameter gifts
  '("twelve Drummers Drumming, " "eleven Pipers Piping, "
    "ten Lords-a-Leaping, " "nine Ladies Dancing, "
    "eight Maids-a-Milking, " "seven Swans-a-Swimming, "
    "six Geese-a-Laying, " "five Gold Rings, " "four Calling Birds, "
    "three French Hens, " "two Turtle Doves, and "
    "a Partridge in a Pear Tree."))

(defun recite (&optional begin end)
  "Returns a string of the requested verse for the 12 days of Christmas."
  (do* ((a (if begin (- (length days) begin) 11) (1- a))
	(b (if end   (- (length days) end) (if begin a 0)))
	res)
       ((= a (1- b)) (format nil "~{~a~^
~}" (reverse res)))
    (push (format nil "On the ~a day of Christmas my true love gave to me: ~{~a~}"
		  (nth a days) (subseq gifts a))
	  res)))
