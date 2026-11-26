#lang racket
(require racket/contract)

(struct robot ([name #:mutable]))

(provide/contract [make-robot (-> robot?)]
                  [name (-> robot? string?)]
                  [reset! (-> robot? void?)]
                  [reset-name-cache! (-> void?)])

(define existing-names (mutable-set))

(define (random-char)
  "Generate a random uppercase letter, as a character"
  (integer->char (+ 65 (random 26))))

(define (random-digit)
  "Generate a random digit 0-9, as a character"
  (integer->char (+ 48 (random 10))))

(define (random-name)
  (define name
    (string (random-char)
            (random-char)
            (random-digit)
            (random-digit)
            (random-digit)))
  (if (set-member? existing-names name)
      (random-name)
      (begin
        (set-add! existing-names name)
        name)))

(define (make-robot)
  (robot (random-name)))

(define (name robot)
  (robot-name robot))

(define (reset! robot)
  (set-robot-name! robot (random-name)))

(define (reset-name-cache!)
  (set! existing-names (mutable-set)))
