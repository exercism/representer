#lang racket
(provide to-rna)

;;; Changes:
;;; the symbol given to (error) now reflects
;;; the name of the function where it happens

(define (mapstring proc str)
  (list->string (map proc (string->list str))))

(define (transcribe nucleotide)
  (define nucleotide-table '((#\G . #\C)
                             (#\C . #\G)
                             (#\T . #\A)
                             (#\A . #\U)))
  (define transcription (assoc nucleotide nucleotide-table))
  (or (and transcription (cdr transcription))
      (error 'transcription "Invalid nucleotide: ~a" nucleotide)))

(define (to-rna dna)
  (mapstring transcribe dna))