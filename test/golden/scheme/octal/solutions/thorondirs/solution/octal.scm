(import (rnrs))
(use-modules (srfi srfi-1))

(define (parse-char c)
  (define char-0 (char->integer #\0))
  (if (char-numeric? c)
    (let ((n-char (- (char->integer c) char-0)))
      (if (< n-char 8)
        n-char
        'NaN))
    'NaN))

(define (helper-builder)
  (define step 0)
  (lambda (c)
    (define current-v (parse-char c))
    (if (number? current-v)
      (let ((ret (* (expt 8 step) current-v)))
        (set! step (1+ step))
        ret)
      'NaN)))


(define (to-decimal s)
  (define helper (helper-builder))
  (define str-list (reverse (string->list s)))
  (define ints (map helper str-list))
  (define (ander num prev)
    (and (number? num) prev))
  (define onlynums (fold ander #t ints))
  (if onlynums
    (fold + 0 ints)
    0))
