(defpackage :lillys-lasagna-leftovers
  (:use :cl)
  (:export
   :preparation-time
   :remaining-minutes-in-oven
   :split-leftovers))

(in-package :lillys-lasagna-leftovers)

(defun preparation-time (&rest e)
"Define function preparation-time"
(* (list-length e) 19))

(defun remaining-minutes-in-oven (&optional (k 337 k-supplied-p))
" Define function remaining-minutes-in-oven"
 (if k-supplied-p(case k
(:normal 337)
(:shorter 237)
(:longer 437)
(:very-long 537)
(:very-short 137)
('nil 0))
k))

(defun split-leftovers (&key (weight 0 weight-supplied-p) (human 10) (alien 10))
  (cond ((not weight-supplied-p) :just-split-it)
          ((null weight) :looks-like-someone-was-hungry)
                  (t (+ weight (+ human alien)))))
