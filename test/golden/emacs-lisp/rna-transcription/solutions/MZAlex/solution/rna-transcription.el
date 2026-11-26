;; rna-transcription.el -- RNA Transcription (exercism)

;;; Commentary:
;;
;;; Code:

(defun check-error (str)
  (if (string-match-p "[^ACGT]" str)
      (error "The dna strand must only contain ACGT as nucleotides")))

(defun convert-nucleotide-rna (char)
  (cond ((= char ?G) ?C)
        ((= char ?C) ?G)
        ((= char ?T) ?A)
        ((= char ?A) ?U)))

(defun to-rna (strand)
  "Given a DNA strand, return its RNA complement"
  (check-error strand)
  (mapconcat
   (lambda (char)
     (string (convert-nucleotide-rna char)))
   strand
   ""))

(provide 'rna-transcription)
;;; rna-transcription.el ends here
