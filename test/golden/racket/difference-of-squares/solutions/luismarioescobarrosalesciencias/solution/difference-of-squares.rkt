#lang racket

(provide sum-of-squares square-of-sum difference)

(define (suma-n n acc)

  (if (= 0 n) acc
  
  ( suma-n (- n 1) (+ acc n))
  
  )
)


(define (suma-n2 n acc)

  (if (= 0 n) acc
  
  ( suma-n2 (- n 1) (+ acc (expt n 2))
  
  )
)
)


(define (sum-of-squares number)
  

    ;(expt (suma-n number 0) 2)
    (suma-n2 number 0)
  
  
  )


(define (square-of-sum number)
  ;(suma-n2 number 0
  (expt (suma-n number 0) 2)
  
  )

(define (difference number)
  (-  (square-of-sum number ) (sum-of-squares number))  )
