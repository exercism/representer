(defpackage :lillys-lasagna-leftovers
  (:use :cl)
  (:export
   :preparation-time
   :remaining-minutes-in-oven
   :split-leftovers))

(in-package :lillys-lasagna-leftovers)

;; Define function preparation-time
(defun preparation-time (&rest layers)
  (* 19 (length layers)))

;; Define function remaining-minutes-in-oven
(defconstant +cooking-times+
  '((:normal . 337)
   (:shorter . 237)
   (:very-short . 137)
   (nil . 0)
   (:longer . 437)
   (:very-long . 537)))
(defun remaining-minutes-in-oven (&optional (cook-time ':normal))
  (let ((entry (assoc cook-time +cooking-times+)))
    (if (null entry)
	(error "How long is ~S?" cook-time)
	(the number (cdr entry)))))

;; Define function split-leftovers
(defun split-leftovers (&key
			  (weight nil known-weight-p)
			  (human 10)
			  (alien 10))
  (if (not known-weight-p)
      ':just-split-it
      (if (null weight)
	  ':looks-like-someone-was-hungry
	  (- weight (+ human alien)))))
