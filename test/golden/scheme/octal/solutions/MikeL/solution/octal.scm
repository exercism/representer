(import (rnrs))

(define (digits s)
  "return list of digits least sig first or '(0) if invalid octal"
  (let ([res (map string->number (string-fold (lambda (c e) (cons (string c) e))  '() s))])
    (if (exists (lambda (e) (or  (equal? e #f) (> e 7))) res)
      '(0)
      res)))

(define (convert l m)
  (cond [(null? l) 0]
        [else (+ (* (car l)  (expt 8 m)) (convert (cdr l) (+ m 1)))]))

(define (to-decimal s)
  (convert  (digits s) 0))


