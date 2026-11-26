(defpackage :twelve-days
  (:use :cl)
  (:export :recite))

(in-package :twelve-days)

(defconstant +days+ '("first" "second" "third" "fourth" "fifth" "sixth" "seventh" "eighth" "ninth" "tenth" "eleventh" "twelfth"))

(defconstant +items+ '("a Partridge in a Pear Tree." "two Turtle Doves, and " "three French Hens, " "four Calling Birds, " "five Gold Rings, " "six Geese-a-Laying, " "seven Swans-a-Swimming, " "eight Maids-a-Milking, " "nine Ladies Dancing, " "ten Lords-a-Leaping, " "eleven Pipers Piping, " "twelve Drummers Drumming, "))

(defun recite (&optional begin (end begin))
  "Returns a string of the requested verses for the 12 Days of Christmas."
  (if (null begin) (setf begin 1 end 12))
  (format nil "On the ~a day of Christmas my true love gave to me: ~a~a" 
          (nth (1- begin) +days+)
          (add-gift (1- begin))
          (if (<= begin end) (format nil "~%~a" (recite (1+ begin) end)) "")))

(defun add-gift (day)
  (if (zerop day) 
      (first +items+)
      (concatenate 'string (nth day +items+) (add-gift (1- day)))))