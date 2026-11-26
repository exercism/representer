#lang racket

(provide encode decode)

(define (encode text)
  (define (format-count char count)
    (if (= count 1)
            (format "~a" char)
            (format "~a~a" count char)))
  (define (encode-helper list count char)
    (cond
      [(null? list) (if (= count 0) "" (format-count char count))]
      [(= count 0) (encode-helper (cdr list) (add1 count) (car list))]
      [(char=? (car list) char) (encode-helper (cdr list) (add1 count) char)]
      [else
       (string-append
        (format-count char count)
        (encode-helper (cdr list) 1 (car list)))]))
  (encode-helper (string->list text) 0 0))


(define (token->pair token)
  (if (= (string-length token) 1)
      (cons 2 token)
      (cons (string->number (substring token 0 (sub1 (string-length token))))
            (substring token (sub1 (string-length token))))))
            
(define (decode code)
  (let* ([tokens (regexp-match* #px"[\\d]*\\D" code)]
         [pairs (map token->pair tokens)]
         [substrings (map (λ (p) (make-string (car p) (string-ref (cdr p) 0)))
                          pairs)])
    (foldr string-append "" substrings)))
