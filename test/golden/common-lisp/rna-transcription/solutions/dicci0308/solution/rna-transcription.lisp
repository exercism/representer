(defpackage :rna-transcription
  (:use :cl)
  (:export :to-rna))
(in-package :rna-transcription)

(defun dna-to-rna-nucleotide (n)
  (case n
    (#\G #\C)
    (#\C #\G)
    (#\T #\A)
    (#\A #\U)))

(defun to-rna (str)
  "Transcribe a string representing DNA nucleotides to RNA."
  (map 'string
       #'dna-to-rna-nucleotide
       str))
