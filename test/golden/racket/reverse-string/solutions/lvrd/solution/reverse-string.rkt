#lang racket

(provide my-reverse)

(define (my-reverse str)
  (apply string (foldl cons '() (string->list str))))