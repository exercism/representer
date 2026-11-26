(defpackage :lillys-lasagna-leftovers
  (:use :cl)
  (:export
   :preparation-time
   :remaining-minutes-in-oven
   :split-leftovers))

(in-package :lillys-lasagna-leftovers)

;; Define function preparation-time
(defun preparation-time (&rest list)
  (* (length list) 19))

;; Define function remaining-minutes-in-oven
(defun remaining-minutes-in-oven (&optional (time :normal))
  (case time
    ((:normal) 337)
    ((:shorter) 237)
    ((:very-short) 137)
    ((:longer) 437)
    ((:very-long) 537)
    ((NIL) 0)))

;; Define function split-leftovers
(defun split-leftovers (&key (weight 0 weight-supplied-p) 
                             (human 0) 
                             (alien 0))
  (cond ((not weight-supplied-p)
           :JUST-SPLIT-IT)
        ((not weight) :LOOKS-LIKE-SOMEONE-WAS-HUNGRY)
        ((and (zerop human)   
              (zerop alien))
              0)
        ((zerop human) alien)
        ((zerop alien) human)
        (T (- weight human alien))))
