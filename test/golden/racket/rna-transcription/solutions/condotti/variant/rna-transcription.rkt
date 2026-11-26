#lang racket

(provide to-rna)

(define (to-rna strand)
  (foldl (lambda (d acc)
           (let ((d-r (assoc d '((#\G . #\C) (#\C . #\G) (#\T . #\A) (#\A . #\U)))))
             (format "~a~a" acc (cdr (and d-r (error "not a nucleotide"))))))
         "" (string->list strand)))
