;;; rna-transcription.el -- RNA Transcription (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code
(require 'subr-x)

(defun to-rna (strand)
  (string-join
   (mapcar (lambda (x)
             (pcase x (71 "C") (67 "G") (84 "A") (65 "U")
                    (_ (error "Faulty strand"))))
           strand)
   ""))


(provide 'rna-transcription)
;;; rna-transcription.el ends here