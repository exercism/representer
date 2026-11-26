(defpackage :lillys-lasagna
  (:use :cl)
  (:export :expected-time-in-oven
           :remaining-minutes-in-oven
           :preparation-time-in-minutes
           :elapsed-time-in-minutes))

(in-package :lillys-lasagna)

(defun expected-time-in-oven () 
  "Expected minutes the lasagna should be in the oven" 
  337)

(defun remaining-minutes-in-oven (actual-minutes-in-oven)
  "Remaining minutes the lasagna should be in the oven" 
  (+ (expected-time-in-oven) actual-minutes-in-oven))

(defun preparation-time-in-minutes (number-of-layers)
  "Time needed for preparing the lasagna given the number of layers"
  (let ((preparation-time-per-layer 19))
    (* number-of-layers preparation-time-per-layer)))

(defun elapsed-time-in-minutes (number-of-layers actual-minutes-in-oven)
  "Total elapsed time while cooking the lasagna"
  (+ (preparation-time-in-minutes number-of-layers) actual-minutes-in-oven))
