(import (rnrs)
        (except (srfi srfi-1) map))

(define (score word)
  (fold (lambda (c t)
          (+ t (case c
                 ((#\a #\e #\i #\o #\u #\l #\n #\r #\s #\t) 1)
                 ((#\d #\g) 2)
                 ((#\b #\c #\m #\p) 3)
                 ((#\f #\h #\v #\w #\y) 4)
                 ((#\k) 5)
                 ((#\j #\x) 8)
                 ((#\q #\z) 10))))
        0
        (map char-downcase (string->list word))))

