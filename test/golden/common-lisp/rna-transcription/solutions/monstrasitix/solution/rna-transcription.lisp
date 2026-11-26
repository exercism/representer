(defpackage :rna-transcription
  (:use :cl)
  (:export :to-rna))
(in-package :rna-transcription)


(defun to-rna-symbol (char)
  (case char
    (#\G #\C)
    (#\C #\G)
    (#\T #\A)
    (#\A #\U)))


(defun to-rna (str)
  "Transcribe a string representing DNA nucleotides to RNA."
  (map 'string #'to-rna-symbol str))
