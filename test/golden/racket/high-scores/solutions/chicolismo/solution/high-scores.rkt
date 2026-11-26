#lang racket

(provide high-scores%)

(define high-scores%
  (class object%
    (init-field values)
    (super-new)
    (define/public (scores) values)
    (define/public (personal-top-three)
      (let ([s (scores)])
        (take (sort s >) (min 3 (length s)))))
    (define/public (personal-best)
      (apply max (scores)))
    (define/public (latest)
      (last (scores)))))
