(defpackage :lillys-lasagna-leftovers
  (:use :cl)
  (:export
   :preparation-time
   :remaining-minutes-in-oven
   :split-leftovers))

(in-package :lillys-lasagna-leftovers)

(defun preparation-time (&rest layers)
  (* (length layers) 19))

(defun remaining-minutes-in-oven
    (&optional (cooking-time :normal cooking-time-set))
  (if (and cooking-time-set
	   (null cooking-time))
      0	   
      (+ 337 (case cooking-time
	       (:very-short -200)
	       (:shorter -100)
	       (:normal 0)
	       (:longer 100)
	       (:very-long 200)
	       (t (error "invalid cooking time"))))))

(defun split-leftovers (&key (weight 0 weight-provided) (human 10) (alien 10) )
  (if weight-provided
      (if (null weight)
	  :looks-like-someone-was-hungry	  
	  (- weight (+ human alien)))
      :just-split-it))
