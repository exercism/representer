;;; rna-transcription.el -- RNA Transcription (exercism)

;;; Commentary:

;; Given a DNA strand, its transcribed RNA strand is formed by replacing
;; each nucleotide with its complement:

;; * `G` -> `C`
;; * `C` -> `G`
;; * `T` -> `A`
;; * `A` -> `U`

;;; Code:

(defvar dna-rna-alist
  '((?G . ?C)
    (?C . ?G)
    (?T . ?A)
    (?A . ?U)))

(defun to-rna (string)
  "Transcribe the DNA STRING to RNA."
  (cl-map 'string
          (lambda (c)
            (cdr (assoc c dna-rna-alist)))
          string))

(provide 'rna-transcription)
;;; rna-transcription.el ends here