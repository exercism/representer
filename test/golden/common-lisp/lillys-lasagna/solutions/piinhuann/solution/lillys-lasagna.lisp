(defpackage :lillys-lasagna
  (:use :cl)
  (:export :expected-time-in-oven
           :remaining-minutes-in-oven
           :preparation-time-in-minutes
           :elapsed-time-in-minutes))

(in-package :lillys-lasagna)

;; Define function expected-time-in-oven
(defun expected-time-in-oven ()
  "fuck"
  337
)

;; Define function remaining-minutes-in-oven
(defun remaining-minutes-in-oven (x)
  "fuck"
  (- (expected-time-in-oven) x)
)

;; Define function preparation-time-in-minutes
(defun preparation-time-in-minutes (x)
  "fuck"
  (* x 19)
)

;; Define function elapsed-time-in-minutes
(defun elapsed-time-in-minutes (layer min)
  "fuck"
  (+ min (preparation-time-in-minutes layer))
)