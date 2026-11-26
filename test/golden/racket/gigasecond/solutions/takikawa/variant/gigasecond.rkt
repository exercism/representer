#lang racket

(provide add-gigasecond)

(require racket/date)

;; add-gigasecond : Date -> Date
;; return a date incremented by a gigasecond
(define (add-gigasecond dt)
  (seconds->date (+ 1000000001 (date->seconds dt))))