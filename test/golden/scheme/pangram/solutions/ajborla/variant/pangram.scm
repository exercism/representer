; ----------------------------------------------------------------------------
; exercism.io
; Scheme Track Exercise: pangram
; Contributed: Anthony J. Borla (ajborla@bigpond.com)
; ----------------------------------------------------------------------------
(import (rnrs))

; Adapted from: https://programming-idioms.org/idiom/119/deduplicate-list/4652/scheme
(define (remove-duplicates xs)
  (cond ((null? xs) '())
         ((member (car xs)
                  (cdr xs)) (remove-duplicates (cdr xs)))
         (else (cons (car xs)
                     (remove-duplicates (cdr xs))))))

(define (string-dedup s)
  (list->string (remove-duplicates (string->list s))))

; Confusing library documentation (srfi, ice-9, r7rs ???), so wrote custom implementation
(define (string-remove-chars cs s)
  (let* ((csl (string->list cs))
         (sl (string->list s))
         (not-mem-csl (lambda (c) (not (member c csl)))))
    (list->string (filter not-mem-csl sl))))

; Punctuation, space, and digits
(define +CHARS-TO-REMOVE+ "!\"#%&'()*,-./:;?@[\\]_{}$ 0123456789")

(define (sanitize s)
  (string-map char-downcase
              (string-remove-chars +CHARS-TO-REMOVE+ s))) 

(define (pangram? phrase)
  (= (string-length (string-dedup (sanitize phrase)))
     27))
