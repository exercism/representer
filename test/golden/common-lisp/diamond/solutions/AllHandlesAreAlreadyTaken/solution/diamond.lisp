(defpackage :diamond
  (:use :cl)
  (:export :rows))

(in-package :diamond)


(defun generate-row (row-num width)
  (let* ((row (make-string width :initial-element #\Space))
         (central-index (floor (/ width 2)))
         (offset-from-center (abs (- central-index row-num)))
         (current-char (code-char (- (+ (char-code #\A) central-index) offset-from-center))))

    (setf (char row offset-from-center) current-char)
    (setf (char row (- width offset-from-center 1)) current-char)
    row))


(defun rows (letter)
  (let* ((letter-distance (- (char-code letter) (char-code #\@)))
         (width (1- (* letter-distance 2))))
    (loop
      for row from 0 to (1- width)
      collect (generate-row row width))))
