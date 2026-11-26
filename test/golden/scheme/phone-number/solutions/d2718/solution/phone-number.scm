(import (rnrs))

;; Aside from digits, these characters are allowed in phone number strings.
(define valid-non-numeric-chars (string->list " -()+."))
;; Area code and exchange code can't begin with these.
(define invalid-leading-digits (list #\0 #\1))


;; Recursive helper function for strip-non-numeric.
;; Call thus:
;; (strip-non-numeric-aux '() char-sequence)
(define (strip-non-numeric-aux accum left)
    (cond
        ((null? left) (reverse accum))
        ((char-numeric? (car left))
            (strip-non-numeric-aux (cons (car left) accum) (cdr left)))
        ((member (car left) valid-non-numeric-chars)
            (strip-non-numeric-aux accum (cdr left)))
        (#t (raise (string-append "invalid character: " (string (car left)))))))

;; Strips all non-numeric characters from the given character sequence.
(define (strip-non-numeric chars)
    (strip-non-numeric-aux '() chars))

;; If this digit sequence has a leading 1 that might possibly be a country
;; code, strip it.
(define (strip-leading-one char-seq)
    (if (and (< 10 (length char-seq))
             (eqv? #\1 (car char-seq)))
        (cdr char-seq)
        char-seq))

;; Clean up a phone number into just its area code and number digits.
;; Barfs on an invalid phone number.
(define (clean phone-number)
    (let ((num-seq (strip-leading-one
                        (strip-non-numeric (string->list phone-number)))))
        (cond
            ((> 10 (length num-seq)) (raise "number too short"))
            ((< 10 (length num-seq)) (raise "number too long"))
            ((member (car num-seq) invalid-leading-digits)
                (raise (string-append "invalid first digit: "
                                      (string (car num-seq)))))
            ((member (list-ref num-seq 3) invalid-leading-digits)
                (raise (string-append "exchange can't begin with "
                                      (string (list-ref num-seq 3)))))
            (#t (list->string num-seq)))))

