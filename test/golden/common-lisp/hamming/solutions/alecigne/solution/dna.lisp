(defpackage #:dna
  (:use #:cl)
  (:export #:hamming-distance))

(in-package #:dna)

(defun hamming-distance (dna1 dna2)
  "Determine number of mutations between DNA strands by computing the Hamming Distance."
  (when (= (length dna1)
           (length dna2))
    (count nil (map 'list #'char= dna1 dna2))))