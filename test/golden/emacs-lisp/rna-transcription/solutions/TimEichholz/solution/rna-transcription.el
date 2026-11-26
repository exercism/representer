;;; rna-transcription.el -- RNA Transcription (exercism)

;;; Commentary:


;;; Code:
(require 'seq)

(defun to-rna (string)
  (seq-into (seq-map (lambda (char)
                        (pcase char
                          (?G ?C)
                          (?C ?G)
                          (?T ?A)
                          (?A ?U)
                          (_ (error "No possible RNA complement"))))
                      string)
             'string))

(provide 'rna-transcription)
;;; rna-transcription.el ends here
