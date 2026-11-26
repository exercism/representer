(defpackage :lillys-lasagna-leftovers
  (:use :cl)
  (:export
   :preparation-time
   :remaining-minutes-in-oven
   :split-leftovers))

(in-package :lillys-lasagna-leftovers)

;; Define function preparation-time
(defun preparation-time (&rest layers)
  "Caluclates the preparation time in minutes for the given layers."
  (* 19
     (length layers)))

;; Define function remaining-minutes-in-oven
(defun remaining-minutes-in-oven (&optional (modifier :normal))
  "Calculates remaining time in oven based on default of 337 minutes and modifying that value based on value of MODIFIER."
  (let ((minutes 337))
    (case modifier
      (:normal minutes)
      (:shorter (- minutes 100))
      (:very-short (- minutes 200))
      (:longer (+ minutes 100))
      (:very-long (+ minutes 200))
      (t 0))))
       

;; Define function split-leftovers
(defun split-leftovers (&key (weight 0 wp) (human 10) (alien 10))
  "Calculate the result of subtracting the sum of HUMAN and ALIEN from WEIGHT"
  (cond ((and wp (null weight)) :LOOKS-LIKE-SOMEONE-WAS-HUNGRY)
	((not wp) :just-split-it)
	(t (- weight (+ human alien)))))
