(defpackage :lillys-lasagna
  (:use :cl)
  (:export :expected-time-in-oven
           :remaining-minutes-in-oven
           :preparation-time-in-minutes
           :elapsed-time-in-minutes))

(in-package :lillys-lasagna)

(defun expected-time-in-oven ()
  "Returns the expected time that a lasagna has to stay in the oven."
  337)

(defun remaining-minutes-in-oven (cooking-for)
  "Returns the additional time in minutes that a lasagna needs to cook."
  (- (expected-time-in-oven) cooking-for))

(defconstant minutes-per-layer 19)

(defun preparation-time-in-minutes (layers)
  "Returns the time in minutes needed to prepare the lasagna."
  (* layers minutes-per-layer))

(defun elapsed-time-in-minutes (layers cooking-for)
  "Returns the total time spent working on the lasagna."
  (+ (preparation-time-in-minutes layers) cooking-for))
