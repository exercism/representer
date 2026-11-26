#lang racket

(provide encode decode)

(define (letter->index c)
  (- (char->integer c) (char->integer #\a)))

(define (index->letter c)
  (integer->char (+ c (char->integer #\a))))

(define (invert-letter c)
  (index->letter (- 25 (letter->index (char-downcase c)))))

(define (chunk lst n)
  (if (<= (length lst) n)
    (list lst)
    (cons (take lst n) (chunk (drop lst n) n))))

(define (filter-alnum chars)
  (filter (lambda (c) (or (char-numeric? c) (char-alphabetic? c))) chars))

(define (atbash-list m)
  (let* ([chars (filter-alnum (string->list m))]
         [inv-chars (map (lambda (c) (if (char-numeric? c) c (invert-letter c))) chars)])
    inv-chars))

(define (encode m)
    (string-join (map list->string (chunk (atbash-list m) 5))))

(define (decode m)
  (list->string (atbash-list m)))
