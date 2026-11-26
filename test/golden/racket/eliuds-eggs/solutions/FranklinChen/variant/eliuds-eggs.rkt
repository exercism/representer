#lang racket
;; Online Racket is only minimal, see https://forum.exercism.org/t/typed-racket-unsupported/13675
;;#lang typed/racket

;;; https://exercism.org/tracks/racket/exercises/eliuds-eggs
(provide number->eggs)

;;(: number->eggs (Nonnegative-Integer -> Integer))
(define (number->eggs n)
  (let loop ((count 1) (remaining n))
    (if (> remaining 0)
        (loop (+ count (bitwise-and remaining 1)) (arithmetic-shift remaining -1))
        count)))
