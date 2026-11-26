(defpackage :lillys-lasagna
  (:use :cl)
  (:export :expected-time-in-oven
           :remaining-minutes-in-oven
           :preparation-time-in-minutes
           :elapsed-time-in-minutes))

(in-package :lillys-lasagna)

;; Define function expected-time-in-oven
(defun expected-time-in-oven ()
  "Expected time in the oven"
  337)

;; Define function remaining-minutes-in-oven
(defun remaining-minutes-in-oven (minutes)
  "Time to remain in the oven"
  (- (expected-time-in-oven) minutes))

;; Define function preparation-time-in-minutes
(defun preparation-time-in-minutes (layers)
  "Time for preparation"
  (* 19 layers))

; Define function elapsed-time-in-minutes
(defun elapsed-time-in-minutes (layers minutes)
  "Total time elapsed"
  (+ (preparation-time-in-minutes layers) minutes))

