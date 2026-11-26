(defpackage :lillys-lasagna
  (:use :cl)
  (:export :expected-time-in-oven
           :remaining-minutes-in-oven
           :preparation-time-in-minutes
           :elapsed-time-in-minutes))

(in-package :lillys-lasagna)

;; Define function expected-time-in-oven
(defun expected-time-in-oven () "Expected time in oven" 337)

;; Define function remaining-minutes-in-oven
(defun remaining-minutes-in-oven (time) "Remaining minutes"
  (- (lillys-lasagna:expected-time-in-oven) time)
)

;; Define function preparation-time-in-minutes
(defun preparation-time-in-minutes (layers) "Preparation time"
  (* layers 19)
)

;; Define function elapsed-time-in-minutes
(defun elapsed-time-in-minutes (layers cooking) "Elapsed time"
  (+ (lillys-lasagna:preparation-time-in-minutes layers) cooking)
)