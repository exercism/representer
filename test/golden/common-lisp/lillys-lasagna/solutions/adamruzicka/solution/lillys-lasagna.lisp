(defpackage :lillys-lasagna
  (:use :cl)
  (:export :expected-time-in-oven
           :remaining-minutes-in-oven
           :preparation-time-in-minutes
           :elapsed-time-in-minutes))

(in-package :lillys-lasagna)

;; Define function expected-time-in-oven
(defun expected-time-in-oven ()
  "According to the Lisp Alien tradition (just like Lilly's parental-unit used to cook), the expected oven time in minutes is 337:"
  337)

;; Define function remaining-minutes-in-oven
(defun remaining-minutes-in-oven (already-elapsed)
  "Takes the actual minutes the lasagna has been in the oven as a parameter and returns how many minutes the lasagna still has to remain in the oven, based on the expected oven time in minutes."
  (- (expected-time-in-oven) already-elapsed))

;; Define function preparation-time-in-minutes
(defun preparation-time-in-minutes (layers)
  "Takes the number of layers Lilly added to the lasagna as a parameter and returns how many minutes Lilly spent preparing the lasagna, assuming each layer takes 19 minutes to prepare."
  (* layers 19))

;; Define function elapsed-time-in-minutes
(defun elapsed-time-in-minutes (layers already-elapsed)
  "Takes two parameters: the first parameter is the number of layers Lilly added to the lasagna, and the second parameter is the number of minutes the lasagna has been in the oven. It returns how many minutes Lilly has worked on cooking the lasagna, which is the sum of the preparation time in minutes, and the time in minutes the lasagna has spent in the oven at the moment."
  (+ (preparation-time-in-minutes layers) already-elapsed))
