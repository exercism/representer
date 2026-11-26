(defpackage :lillys-lasagna-leftovers
  (:use :cl)
  (:export
   :preparation-time
   :remaining-minutes-in-oven
   :split-leftovers))

(in-package :lillys-lasagna-leftovers)
(defun expected-time-in-oven () "." 337)
;; Define function preparation-time
(defun preparation-time (&rest r) (* 19 (length r)))
;; Define function remaining-minutes-in-oven
(defun remaining-minutes-in-oven (&optional (keyword :normal))
 (case keyword
       (:normal     (expected-time-in-oven))
       (:shorter    (- (expected-time-in-oven) 100))
       (:very-short (- (expected-time-in-oven) 200))
       (:longer     (+ (expected-time-in-oven) 100))
       (:very-long  (+ (expected-time-in-oven) 200))
       ('()         0)))
;; Define function split-leftovers
(defun split-leftovers
  (&key (alien 10) (human 10) (weight nil w-supplied-p))
  (cond (weight        (- weight alien human))
        (w-supplied-p :looks-like-someone-was-hungry)
        (t            :just-split-it)))

