(defpackage :lillys-lasagna
  (:use :cl)
  (:export :expected-time-in-oven
           :remaining-minutes-in-oven
           :preparation-time-in-minutes
           :elapsed-time-in-minutes))

(in-package :lillys-lasagna)

;; Define function expected-time-in-oven
(defun expected-time-in-oven ()
  "The minutes it takes to cook lasagna in the oven."
  337)

;; Define function remaining-minutes-in-oven
(defun remaining-minutes-in-oven (minutes)
  "Minutes remaining until the lasagna is ready given MINUTES already cooked."
  (- (expected-time-in-oven) minutes))

;; Define function preparation-time-in-minutes
(defun preparation-time-in-minutes (layers)
  "Prep time given the number of LAYERS."
  (* layers 19))

;; Define function elapsed-time-in-minutes
(defun elapsed-time-in-minutes (layers minutes)
  "Minutes worked on lasagna given lasagna LAYERS and MINUTES in oven."
  (+ (preparation-time-in-minutes layers) minutes))
