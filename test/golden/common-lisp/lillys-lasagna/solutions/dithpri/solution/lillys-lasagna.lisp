(defpackage :lillys-lasagna
  (:use :cl)
  (:export :expected-time-in-oven
           :remaining-minutes-in-oven
           :preparation-time-in-minutes
           :elapsed-time-in-minutes))

(in-package :lillys-lasagna)

;; Define function expected-time-in-oven
(defun expected-time-in-oven nil
  "Expected minutes in oven"
  337)
;; Define function remaining-minutes-in-oven
(defun remaining-minutes-in-oven (minutes-in-oven)
  "Remaining minutes in oven"
  (- (expected-time-in-oven) minutes-in-oven))

;; Define function preparation-time-in-minutes
(defun preparation-time-in-minutes (layers)
  "Preparation time in minutes of the lasagna, depending on number of layers"
  (* 19 layers))

;; Define function elapsed-time-in-minutes
(defun elapsed-time-in-minutes (layers minutes-in-oven)
  "Elapsed time in minutes, depending on layers and minutes in oven"
  (+ (preparation-time-in-minutes layers) minutes-in-oven)
  )