;;; rna-transcription.el -- RNA Transcription (exercism)

;;; Commentary:

;;; Code:

(defun to-rna (dna)
  (let ((map-nucleotide (lambda (n)
						  (cond ((eq n ?G) ?C)
								((eq n ?C) ?G)
								((eq n ?T) ?A)
								((eq n ?A) ?U)
								(t (error "Invalid nucleotide")))
						  )))
	(concat (seq-map map-nucleotide dna))
	)
  )

(provide 'rna-transcription)
;;; rna-transcription.el ends here
