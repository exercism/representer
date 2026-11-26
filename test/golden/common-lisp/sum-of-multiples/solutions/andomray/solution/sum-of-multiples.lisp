(defpackage :sum-of-multiples
  (:use :cl)
  (:export :sum))

(in-package :sum-of-multiples)

(defun generate-multiples (factors limit)
  (remove-duplicates
   (loop for n from 1 to (1- limit)
         nconc (loop for f in factors
                     when (zerop (mod n f))
                       collect n))))

(defun sum (factors limit)
  (let ((factors (remove-if #'zerop factors)))
    (if (zerop (length factors))
        0
        (reduce #'+ (generate-multiples factors limit)))))
