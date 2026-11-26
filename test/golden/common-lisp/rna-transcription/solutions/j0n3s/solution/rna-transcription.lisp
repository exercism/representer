(defpackage :rna-transcription
  (:use :cl)
  (:export :to-rna))
(in-package :rna-transcription)

(defun to-rna (str)
  "Transcribe a string representing DNA nucleotides to RNA."
  (coerce
   (mapcar
    (lambda (x)
      (case x
        (#\G #\C)
        (#\C #\G)
        (#\T #\A)
        (#\A #\U)))
    (coerce str 'list))
   'string))
