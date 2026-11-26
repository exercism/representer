(defpackage :rna-transcription
  (:use :cl)
  (:export :to-rna))
(in-package :rna-transcription)

(defun to-rna (str) "Transcribe a string representing DNA nucleotides to RNA."
  (cond ((= (length str) 0) "")
        ((equal #\G (char str 0)) (concatenate 'string "C" (to-rna (subseq str 1))))
        ((equal #\C (char str 0)) (concatenate 'string "G" (to-rna (subseq str 1))))
        ((equal #\T (char str 0)) (concatenate 'string "A" (to-rna (subseq str 1))))
        ((equal #\A (char str 0)) (concatenate 'string "U" (to-rna (subseq str 1))))
        (t (error "that is not a valid dna strand"))))
