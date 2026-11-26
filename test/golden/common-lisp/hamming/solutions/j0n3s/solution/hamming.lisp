(defpackage :hamming
  (:use :cl)
  (:export :distance))

(in-package :hamming)

(defun distance (dna1 dna2)
  "Number of positional differences in two equal length dna strands."
  (let ((d1 (coerce dna1 'list))
        (d2 (coerce dna2 'list)))
    (if (= (length d1) (length d2))
        (length
         (remove-if
          (lambda (x) (char= (first x) (second x)))
          (mapcar 'list d1 d2))))))
