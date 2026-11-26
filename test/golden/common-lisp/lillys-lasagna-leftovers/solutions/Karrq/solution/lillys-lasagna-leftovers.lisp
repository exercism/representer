(defpackage :lillys-lasagna-leftovers
  (:use :cl)
  (:export
   :preparation-time
   :remaining-minutes-in-oven
   :split-leftovers))

(in-package :lillys-lasagna-leftovers)

;; Define function preparation-time
(defun preparation-time (&rest layers)
  (* (length layers) 19))

;; Define function preparation-time
(defun preparation-time (&rest layers)
  (* (length layers) 19))

;; Define function remaining-minutes-in-oven
(defun remaining-minutes-in-oven (&optional (modifier :normal))
  (case modifier
    (:normal 337)
    (:shorter (- 337 100))
    (:very-short (- 337 200))
    (:longer (+ 337 100))
    (:very-long (+ 337 200))
    ('nil 0)))

;; Define function split-leftovers
(defun split-leftovers (&key (weight nil weight-p) (human 10) (alien 10))
  (cond
    (weight (- weight (+ human alien)))
    ;weight proivided, but was nil
    (weight-p :looks-like-someone-was-hungry)
    ;weight not provided
    (t :just-split-it)))

