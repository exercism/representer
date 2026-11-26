;;; hamming.el --- Hamming (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun hamming-distance (dna1 dna2)
  "function to compute the hamming distance between two strings"
  (unless (= (length dna1) (length dna2))
      (error "strings difffrent lengths"))
  (cl-count nil (cl-mapcar #'= (string-to-list dna1) (string-to-list dna2))))

(provide 'hamming)
;;; hamming.el ends here
