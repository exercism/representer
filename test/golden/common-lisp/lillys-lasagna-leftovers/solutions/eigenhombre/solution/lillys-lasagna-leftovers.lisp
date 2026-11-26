(defpackage :lillys-lasagna-leftovers
  (:use :cl)
  (:export
   :preparation-time
   :remaining-minutes-in-oven
   :split-leftovers))

(in-package :lillys-lasagna-leftovers)

;; Define function preparation-time
(defun preparation-time (&rest args)
  (* 19 (length args)))

;; Define function remaining-minutes-in-oven
(let ((unsupplied (gensym "not-provided")))
  (defun remaining-minutes-in-oven (&optional (lenkw unsupplied))
    (if (null lenkw)
        0
        (case lenkw
          (:shorter 237)
          (:very-short 137)
          (:longer 437)
          (:very-long 537)
          (t 337)))))

;; Define function split-leftovers
(let ((unsupplied (gensym "not-provided")))
  (defun split-leftovers (&key (weight unsupplied) (human 10) (alien 10))
    (cond
      ((equal weight unsupplied) :just-split-it)
      ((null weight) :looks-like-someone-was-hungry)
      (t (- weight human alien)))))
