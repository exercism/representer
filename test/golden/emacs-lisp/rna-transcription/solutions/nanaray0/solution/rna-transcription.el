;;; rna-transcription.el -- RNA Transcription (exercism)

;;; Commentary:

;; Thank you for teaching me about `pcase'

;;; Code:

(require 'seq)

(defun to-rna (s)
  "Given a DNA strand S, return its RNA complement."
  (concat (seq-map (lambda (e)
                     (pcase e
                       (?G ?C)
                       (?C ?G)
                       (?T ?A)
                       (?A ?U)
                       (_ (error "Invalid nucleotide"))))
                   s)))

(provide 'rna-transcription)
;;; rna-transcription.el ends here
