;;; rna-transcription.el -- RNA Transcription (exercism)

;;; Commentary:



;;; Code:

(defun to-rna (dna)
  (let ((component-mapping '((?G . ?C)
                             (?C . ?G)
                             (?T . ?A)
                             (?A . ?U))))
    (concat (mapcar (lambda (nucleo)
                      (if (eq (cdr (assoc nucleo component-mapping)) nil)
                          (error "unrecognized nucleotide")
                        (cdr (assoc nucleo component-mapping)))) dna))))



(provide 'rna-transcription)
;;; rna-transcription.el ends here
