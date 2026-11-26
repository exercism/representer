(defpackage :rna-transcription
  (:use :cl)
  (:export :to-rna))
(in-package :rna-transcription)

(defun transcribe-nucleotide (char)
  (ecase char
	(#\G #\C)
	(#\C #\G)
	(#\T #\A)
	(#\A #\U)))

(defun to-rna (str)
  "Transcribe a string representing DNA nucleotides to RNA."
  (map 'string #'transcribe-nucleotide str))
