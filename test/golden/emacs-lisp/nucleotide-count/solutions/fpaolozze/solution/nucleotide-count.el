;;; nucleotide-count.el --- nucleotide-count Exercise (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;; (sort '((?G . 1) (?C . 2)) (lambda (i1 i2) (< (car i1) (car i2))))

(defconst nucleotide-strands '(?A ?C ?G ?T))

(defun nucleotide-count--create-table ()
  "Return a new hash-table to use as counter."
  (let ((counter (make-hash-table)))
    (dolist (strand nucleotide-strands)
      (puthash strand 0 counter))
    counter))

(defun nucleotide-count (sequence)
  "Return a sorted list of nucleotide occurrences in SEQUENCE."
  (let ((counter (nucleotide-count--create-table))
        (result))
    (dolist (strand (string-to-list sequence))
      (puthash strand (+ (gethash strand counter) 1) counter))

    (maphash (lambda (strand count) (add-to-list 'result `(,strand . ,count))) counter)
    result))

(provide 'nucleotide-count)
;;; nucleotide-count.el ends here
