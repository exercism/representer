(defpackage :hamming
  (:use :cl)
  (:export :distance))

(in-package :hamming)

(defun checker (list)
  (eq (first list) (second list)))

(defun distance (dna1 dna2)
  "Number of positional differences in two equal length dna strands."
    (cond
      ((string= dna1 dna2) 0)
      ((not (= (length dna1) (length dna2))) nil)
      (t (length (remove-if #'checker
         (loop for x across dna1 for y across dna2
               collect (list x y)))))))
