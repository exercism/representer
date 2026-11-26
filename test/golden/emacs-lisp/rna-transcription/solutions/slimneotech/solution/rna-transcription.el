;;; rna-transcription.el -- RNA Transcription (exercism)

;;; Commentary:

;;; Code:
(setq dna-rna '((?G . "C") (?C . "G") (?T . "A") (?A . "U")))

(defun to-rna (data)
  (mapconcat (lambda (val) (or (cdr (assoc val dna-rna)) (error "Invalid nucleotide"))) data "")
)

(provide 'rna-transcription)
;;; rna-transcription.el ends here
