;;; rna-transcription.el -- RNA Transcription (exercism)

;;; Commentary:



;;; Code:

(defun to-rna (dna)
  "DNA."
  (concat (mapcar '--transcribe dna)))

(defun --transcribe (nucleotide)
  "Transcribe a DNA NUCLEOTIDE to RNA nucleotide.  Raise error on invalid NUCLEOTIDE."
  (cond
   ((= nucleotide ?G) ?C)
   ((= nucleotide ?C) ?G)
   ((= nucleotide ?T) ?A)
   ((= nucleotide ?A) ?U)
   (t (error "Invalid nucleotide"))))

(provide 'rna-transcription)
;;; rna-transcription.el ends here

