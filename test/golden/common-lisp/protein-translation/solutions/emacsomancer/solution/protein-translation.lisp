(defpackage :protein-translation
  (:use :cl)
  (:export :proteins
           :invalid-protein))

(in-package :protein-translation)

(define-condition invalid-protein (error)
  ((text :initarg :text :reader text)))

(defun proteins (strand)
  (let ((codons (segment-codons strand)))
    (let ((read-codons codons)
          (pro-seq-list nil))
      (loop while (not (null read-codons))
            do (let ((curr-codon (car read-codons)))
                     (if (member curr-codon (list "UAA" "UAG" "UGA") :test #'string=)
                         (setf read-codons nil)
                         (progn 
                           (cond ((string= curr-codon "AUG")
                                  (setf pro-seq-list (append pro-seq-list
                                                             (list "Methionine"))))
                                 ((member curr-codon (list "UUU" "UUC") :test #'string=)
                                  (setf pro-seq-list (append pro-seq-list
                                                             (list "Phenylalanine"))))
                                 ((member curr-codon (list "UUA" "UUG") :test #'string=)
                                  (setf pro-seq-list (append pro-seq-list
                                                             (list "Leucine"))))
                                 ((member curr-codon (list "UCU" "UCC" "UCA" "UCG") :test #'string=)
                                  (setf pro-seq-list (append pro-seq-list
                                                             (list "Serine"))))
                                 ((member curr-codon (list "UAU" "UAC") :test #'string=)
                                  (setf pro-seq-list (append pro-seq-list
                                                             (list "Tyrosine"))))
                                 ((member curr-codon (list "UGU" "UGC") :test #'string=)
                                  (setf pro-seq-list (append pro-seq-list
                                                             (list "Cysteine"))))
                                 ((string= curr-codon "UGG")
                                  (setf pro-seq-list (append pro-seq-list
                                                             (list "Tryptophan"))))
                                 (t (error 'invalid-protein)))
                           (setf read-codons (cdr read-codons))))))
      pro-seq-list)))


(defun segment-codons (rna)
  (let ((rnalng (length rna))
        (codon-lst nil)
        (n 0))
    (loop while (< n rnalng)
          do (let ((m (if (< (+ n 3) rnalng)
                          (+ n 3)
                          rnalng)))
               (setf codon-lst (append
                                codon-lst
                                (list (subseq rna n m))))
               (setf n (+ n 3))))
    codon-lst))
