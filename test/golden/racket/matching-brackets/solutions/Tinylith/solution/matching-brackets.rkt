#lang racket

(provide balanced?)

(define (balanced? str)
  (define (opener br)
    (case br [(#\)) #\(] [(#\]) #\[] [(#\}) #\{]))
  (let/ec break
    (for/fold ([left null]
               #:result (null? left))
              ([ch (in-string str)])
      (cond
        [(member ch '(#\( #\[ #\{)) (cons ch left)]
        [(member ch '(#\) #\] #\}))
         (if (or (null? left)
                 (not (char=? (opener ch) (car left))))
             (break #f)
             (cdr left))]
        [else left]))))
