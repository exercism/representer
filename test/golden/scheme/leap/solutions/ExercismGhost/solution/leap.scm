(import (rnrs))

(define (leap-year? year)
  (and (= (remainder year 4) 0)
       (or (not (= (remainder year 100) 0))
           (= (remainder year 400) 0))))

