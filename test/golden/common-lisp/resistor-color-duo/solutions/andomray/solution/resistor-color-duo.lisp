(defpackage :resistor-color-duo
  (:use :cl)
  (:export :value))

(in-package :resistor-color-duo)

(defparameter rtable (make-hash-table :test #'equal))
(setf (gethash "black" rtable) 0)
(setf (gethash "brown" rtable) 1)
(setf (gethash "red" rtable) 2)
(setf (gethash "orange" rtable) 3)
(setf (gethash "yellow" rtable) 4)
(setf (gethash "green" rtable) 5)
(setf (gethash "blue" rtable) 6)
(setf (gethash "violet" rtable) 7)
(setf (gethash "grey" rtable) 8)
(setf (gethash "white" rtable) 9)

(defun value (colors)
  (let* ((v1 (gethash (car colors) rtable))
         (v2 (gethash (cadr colors) rtable))
         (num (format nil "~{~A~}" (list v1 v2))))
    (parse-integer num)))
