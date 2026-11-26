(defpackage :rna-transcription
  (:use :cl)
  (:export :to-rna))
(in-package :rna-transcription)

(defun to-rna (str)
  "Transcribe a string representing DNA nucleotides to RNA.
Given a DNA strand, its transcribed RNA strand is formed by replacing each nucleotide with its complement:
* `G` -> `C`
* `C` -> `G`
* `T` -> `A`
* `A` -> `U`
"
  (let ((dna-to-rna (list (cons #\G #\C)
                          (cons #\C #\G)
                          (cons #\T #\A)
                          (cons #\A #\U))))
    (map
     'string
     #'(lambda (e)
         (cdr (assoc e dna-to-rna)))
     str)))
