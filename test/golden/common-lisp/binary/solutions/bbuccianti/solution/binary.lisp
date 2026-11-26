(defpackage #:binary
  (:use :cl)
  (:export #:to-decimal))

(in-package #:binary)

(defun to-decimal (str)
  (let ((binary-number (loop for c in (coerce (reverse str) 'list)
			  when (digit-char-p c)
			  collect (string c))))
    (loop for x in binary-number
     for e from 0
     when (equal x "1")
     sum (expt 2 e))))
