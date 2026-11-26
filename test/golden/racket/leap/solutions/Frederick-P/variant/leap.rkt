#lang racket

(provide leap-year?)

(define (leap-year? year)
  (= 0 (bitwise-and year (if (= 0 (modulo year 100)) 16 3)))
  )

;; #240116
;; (define (leap-year? year)
  ;; (error "Not implemented yet"))
  ;; (if (not (= 0 (modulo year 100)))
  ;;     (= 0 (modulo year 4))
  ;;     (= 0 (modulo year 400)))
  ;; )
