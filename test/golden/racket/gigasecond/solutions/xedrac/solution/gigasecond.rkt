#lang racket

(provide add-gigasecond)

(require racket/date)

(define (add-gigasecond d)
  (seconds->date (+ (date->seconds d) 1000000000)))