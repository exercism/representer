;;; protein-translation.el --- Protein Translation (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(require 'cl-lib)

(defvar *codon-table* (let ((table (make-hash-table :test 'equal)))
                        (puthash "AUG" "Methionine" table)
                        (puthash "UUU" "Phenylalanine" table)
                        (puthash "UUC" "Phenylalanine" table)
                        (puthash "UUA" "Leucine" table)
                        (puthash "UUG" "Leucine" table)
                        (puthash "UCU" "Serine" table)
                        (puthash "UCC" "Serine" table)
                        (puthash "UCA" "Serine" table)
                        (puthash "UCG" "Serine" table)
                        (puthash "UAU" "Tyrosine" table)
                        (puthash "UAC" "Tyrosine" table)
                        (puthash "UGU" "Cysteine" table)
                        (puthash "UGC" "Cysteine" table)
                        (puthash "UGG" "Tryptophan" table)
                        (puthash "UAA" nil table)
                        (puthash "UAG" nil table)
                        (puthash "UGA" nil table)
                        table))

(defun translate (codon)
  (let ((protein (gethash codon *codon-table* 'not-found)))
    (if (eq protein 'not-found)
        (error "Invalid codon: %s" codon)
      protein)))

(defun proteins (strand)
  (let* ((len (length strand))
         (stop (- len (% len 3))))
    (cl-labels
        ((recur (index)
           (if (= index stop)
               (unless (= index len) (error "Invalid codon"))
             (let* ((next (+ index 3))
                    (protein (translate (substring strand index next))))
               (when protein (cons protein (recur next)))))))
      (recur 1))))


(provide 'protein-translation)
;;; protein-translation.el ends here
