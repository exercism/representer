(import (rnrs))

;(define (square n)
;  'implement-me!)

;(define total
;  'implement-me!)


; Calculate 2 ^ (n-1)
; real -> real
(define (square n)
  (if (<= n 0)
      (assertion-violation
       ’square "square 0" n))
  (if (> n 64)
      (assertion-violation
       ’square "square 64" n))  
  (expt 2 (sub1 n)))


; Output a new list that has all elements but last one
; if the parameter is empty list, then output empty list
; [list] -> [list]
(define (all-but-last xs)
  (cond [(null? xs) xs]
        [else (take xs (sub1 (length xs)))]))


; sum up all of the elements of a list
; [real] -> real
(define (sum xs)
  (apply + xs))


; Output a list whose elements ranged in [start, end)
; int -> int -> [int]
(define (range start end)
    (cond [(= start end) '()]
          [else (cons start (range (add1 start) 
                                   end))]))

; Calculate the total amount of grains
; ()->integer
(define (total)
  (sum (map square (range 1 65))))
