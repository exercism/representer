(import (rnrs))

(define alphabet '(#\a #\b #\c #\d #\e #\f #\g #\h #\i #\j #\k #\l #\m #\n #\o #\p #\q #\r #\s #\t #\u #\v #\w #\x #\y #\z))

(define (check-for-pangram phrase alpha)
  (let ((p (string->list (string-downcase phrase))))
    (cond
     ((null? alpha) #t)
     ((not (memv (car alpha) p)) #f)
     (else (check-for-pangram phrase (cdr alpha))))))

(define (pangram? phrase)
  (if (zero? (string-length phrase))
    #f
    (check-for-pangram phrase alphabet)))
