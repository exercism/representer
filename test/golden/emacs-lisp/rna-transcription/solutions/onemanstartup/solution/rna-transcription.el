;;; rna-transcription.el -- RNA Transcription (exercism)

;;; Commentary:



;;; Code:


(defun to-rna (rna)
  (mapconcat 'convert-nucleotide rna nil))

(defun convert-nucleotide (nucleotide)
  (pcase nucleotide
    (?C "G") (?G "C") (?A "U") (?T "A")
    (_ (error "Invalid RNA"))))

(provide 'rna-transcription)
;;; rna-transcription.el ends here