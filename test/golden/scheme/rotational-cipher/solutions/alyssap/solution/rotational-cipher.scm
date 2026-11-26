(import (rnrs))

(define (string-map proc s)
  (let ((result (string-copy s))
        (len (string-length s)))
    (let loop ((i 0))
      (if (< i len)
          (begin
            (string-set! result i (proc (string-ref s i)))
            (loop (+ 1 i)))
          result))))

(define (char-rotator amount)
  (lambda (char)
    (cond
     ((char-alphabetic? char)
      (let ((base (char->integer (if (char-upper-case? char) #\A #\a))))
        (integer->char (+ base (modulo (+ (char->integer char) (- base) amount) 26)))))
     (else char))))

(define (rotate phrase dx)
  (string-map (char-rotator dx) phrase))

