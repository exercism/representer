#lang racket

(provide encode decode)

(define (one? n) (= n 1))
(define (many? n) (> n 1))
(define (count? c) (non-empty-string? c))

(define (encode text)
  (define plain (string->list text))
  (define (iter encoded count last rest)
    (cond
      ; end of input: deal with new or repeated char at the end
      ((and (null? rest) (one? count)) (string-append encoded (string last)))
      ((and (null? rest) (many? count)) (string-append encoded (number->string count) (string last)))
      ; next character same as last: increase the count and iterate
      ((char=? last (car rest)) (iter encoded (add1 count) last (cdr rest)))
      ; next character differs: add to the encoded, cases for single or multiple last character
      (else (if (one? count)
                (iter (string-append encoded (string last))  1 (car rest) (cdr rest))
                (iter (string-append encoded (number->string count) (string last)) 1 (car rest) (cdr rest))))))
  (if (null? plain)
      ""
      (iter "" 1 (car plain) (cdr plain))))


(define (decode code)
  (define plain (string->list code))
  (define (iter encoded countstring rest)
    (if (null? rest)
        encoded
        (let ([first (car rest)])
          ;; (displayln (format "1st: ~a cs: ~a, enc: ~a" first countstring encoded))
          (cond
            ; end of input: deal with new or repeated char at the end
            ((char-numeric? first) (iter encoded (string-append countstring (string first)) (cdr rest)))
            ((count? countstring) (iter (string-append encoded (make-string (string->number countstring) first)) "" (cdr rest)))
            (else (iter (string-append encoded (string first)) "" (cdr rest))))))) 
  (iter "" "" plain))

