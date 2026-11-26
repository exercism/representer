#lang racket
(provide my-reverse)

(define (my-reverse s)
  (define (h s res) 
    (cond [(string=? "" s) res ]
          [else (h (substring s  1 ) (string-append  (string(string-ref s 0))  res ))]
    )  
  )
  (h s "")
)



