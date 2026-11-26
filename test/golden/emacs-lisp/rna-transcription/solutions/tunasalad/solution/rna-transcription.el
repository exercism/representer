;;; rna-transcription.el -- RNA Transcription (exercism)  -*- lexical-binding: t; -*-

(defun to-rna (strand)
  (cl-map 'string
          (lambda (c)
            (pcase c
              (?A ?U)
              (?T ?A)
              (?C ?G)
              (?G ?C)
              (_ (error "not in ATCG"))))
          strand))

(provide 'rna-transcription)
;;; rna-transcription.el ends here
