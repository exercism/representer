#lang racket

(provide classify)

(define (sum L)
  ( cond
     [ (null? L) 1 ]
     [ #t (+ (car L) (sum (cdr L)) ) ]
     )
  )

(define (divides? n m)
  (if (= (modulo m n) 0) #t #f))

(define (factors2 n k)
  (cond
           [(= k 1) (list 1)]
          [ (divides? k n) (cons k (factors2 n (- k 1))) ]
          [ #t (factors2 n (- k 1)) ]
          )
  )
(define (factors n)
  (factors2 n n)
  )

(define (aliquot_sum num)
  (sum (cdr (factors num)))
  )

(define (classify number)
   (cond
      [ (= (aliquot_sum number) number) 'perfect]
      [ (> (aliquot_sum number) number) 'abundant]
      [ (< (aliquot_sum number) number) 'deficient]
      )
)
