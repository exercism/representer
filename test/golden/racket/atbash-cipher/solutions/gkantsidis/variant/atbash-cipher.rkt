#lang racket

(provide encode decode)

(define (index-of-char c)
  (- (char->integer c) (char->integer #\a)))

(define (encode-char c)
  (integer->char
   (+ (char->integer #\a)
      (- 25 (index-of-char c)))))

(define (decode-char c)
  (encode-char c))
      
(define (encode m)
  (define (next chars remaining)
    (match remaining
      [ '() (reverse chars) ]
      [ (list head tail ...)
        (cond
          [(char-numeric? head) (next (cons head chars) tail)]
          [(char-alphabetic? head) (next (cons (encode-char head) chars) tail)]
          [else (next chars tail)])]))
  (define encoded (next '() (map char-downcase (string->list m))))
  (define (unroll acc index lst)
    (cond
      [(null? lst) (reverse acc)]
      [(= 0 index) (unroll (cons #\space acc) 6 lst)]
      [else
       (let ([head (car lst)]
             [tail (cdr lst)])
         (unroll (cons head acc) (- index 1) tail))]))

  (list->string (unroll '() 5 encoded)))
           
(define (decode m)
  (define (char-not-whitespace? c)
    (not (char-whitespace? c)))
  (define digits
    (filter char-not-whitespace? (string->list m)))
  (define (decode-all-char c)
    (cond
      [(char-numeric? c) c]
      [else (decode-char c)]))
  (define decoded (map decode-all-char digits))
  (list->string decoded))
