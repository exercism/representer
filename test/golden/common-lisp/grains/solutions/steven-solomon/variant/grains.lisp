(in-package #:cl-user)
(defpackage #:grains
  (:use #:cl)
  (:export :square :total))
(in-package #:grains)

(defun square (n)
  (expt 2 (+ n 1)))

(defun total ()
  (reduce '+ (all-grains)))

(defun all-grains () 
  (loop for i from 1 upto 64
        collect (square i)))