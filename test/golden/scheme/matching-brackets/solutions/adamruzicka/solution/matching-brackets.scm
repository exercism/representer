(import (rnrs))

(define opening '(#\( #\[ #\{))
(define closing '(#\) #\] #\}))

(define (closing-pair? p1 p2)
  (or
   (and (char=? p1 #\() (char=? p2 #\)))
   (and (char=? p1 #\[) (char=? p2 #\]))
   (and (char=? p1 #\{) (char=? p2 #\}))))

(define (balanced? string)
  (define (inner-balanced? chars stack)
    (if (null? chars)
        (null? stack)
        (inner-balanced-nonempty (car chars) (cdr chars) stack)))

  (define (inner-balanced-nonempty head rest stack)
    (define (handle-closing-bracket)
      (cond
       ((null? stack) #f)
       ((closing-pair? (car stack) head) (inner-balanced? rest (cdr stack)))
       (else #f)))

    (cond
     ((memq head opening) (inner-balanced? rest (cons head stack)))
     ((memq head closing) (handle-closing-bracket))
     (else (inner-balanced? rest stack))))

  (inner-balanced? (string->list string) '()))

