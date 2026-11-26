#lang racket
(require racket/contract)
(require math/number-theory)
(require racket/set)

(provide (contract-out
          [encode (string?
                   exact-nonnegative-integer?
                   exact-nonnegative-integer? . -> . string?)]
          [decode (string?
                   exact-nonnegative-integer?
                   exact-nonnegative-integer? . -> . string?)]))

(define (encode msg a b)
  (cond
    [(is-coprime? a alphabet-length)
     (list->string (separate
       (filter char? (map (lambda (i) (encrypt a i b alphabet-length)) (string->list msg)))))]
    [else (error "Error: a and m must be coprime.")]))

(define (decode msg a b)
  (cond
    [(is-coprime? a alphabet-length)
     (list->string
       (map (lambda (y) (index-to-alphabet (decrypt a y b alphabet-length))) (filter char-alphanumeric? (string->list msg))))]
    [else (error "Error: a and m must be coprime.")]))

(define (encrypt a x b m)
  (cond
    [(char-numeric? x) x]
    [(char-alphabetic? x) (index-to-alphabet (modulo (+ (* a (alphabet-index x)) b) m))]
    [else #f]))

(define (decrypt a y b m)
  (cond
    [(char-alphabetic? y) (modulo (* (mmi a alphabet-length) (- (alphabet-index y) b)) alphabet-length)]
    [else y]))

(define alphabet (quote "abcdefghijklmnopqrstuvwxyz"))
(define alphabet-length (string-length alphabet))

(define (is-coprime? a b)
  (let ([a-divisors (list->set (divisors a))]
        [b-divisors (list->set (divisors b))])
        (equal? 1 (set-count (set-intersect a-divisors b-divisors)))))

; return index of char in alphabet
(define (alphabet-index c)
  (let ([alphabet (string->list alphabet)])
    (index-of alphabet (char-downcase c))))

; return character in alphabet if parameter is a number
(define (index-to-alphabet i)
  (cond
    [(number? i) (string-ref alphabet i)]
    [else i]))

; find the modular multiplicative inverse of a
(define (mmi a m)
  (findf (lambda (n)
           (= 1 (modulo (* a n) m)))
         (range 0 alphabet-length)))

; add a space between every 5 chars
(define (separate lst)
  (cond [(= (length lst) 0) '()]
        [(<= (length lst) 5) lst]
        [else (append (take lst 5) (list #\space) (separate (drop lst 5)))]))

(define (char-alphanumeric? c)
  (and (char-numeric? c) (char-alphabetic? c)))