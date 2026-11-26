#lang racket

(provide proteins)

(define (proteins strand)
  (translate (map list->string (chunks (string->list strand)))))

(define (translate chunks)
  (match chunks
    ['() empty]
    [(cons "AUG" xs) (cons "Methionine" (translate xs))]
    [(cons "UUU" xs) (cons "Phenylalanine" (translate xs))]
    [(cons "UUC" xs) (cons "Phenylalanine" (translate xs))]
    [(cons "UUA" xs) (cons "Leucine" (translate xs))]
    [(cons "UUG" xs) (cons "Leucine" (translate xs))]
    [(cons "UCU" xs) (cons "Serine" (translate xs))]
    [(cons "UCC" xs) (cons "Serine" (translate xs))]
    [(cons "UCA" xs) (cons "Serine" (translate xs))]
    [(cons "UCG" xs) (cons "Serine" (translate xs))]
    [(cons "UAU" xs) (cons "Tyrosine" (translate xs))]
    [(cons "UAC" xs) (cons "Tyrosine" (translate xs))]
    [(cons "UGU" xs) (cons "Cysteine" (translate xs))]
    [(cons "UGC" xs) (cons "Cysteine" (translate xs))]
    [(cons "UGG" xs) (cons "Tryptophan" (translate xs))]
    [(cons "UAA" _) empty]
    [(cons "UAG" _) empty]
    [(cons "UGA" _) empty]
    [(cons x _) (raise (exn:fail x (current-continuation-marks)))]))

(define (chunks xs)
  (cond
    [(empty? xs) empty]
    [(< (length xs) 3) (list xs)]
    [else (cons (take xs 3) (chunks (drop xs 3)))]))
