#lang racket

(provide (struct-out character)
         ability
         make-character
         modifier)

(struct character
    (strength
     dexterity
     constitution
     intelligence
     wisdom
     charisma
     hitpoints)) ; Add necessary struct fields

(define (ability)
  (define total-point 0)
  (define min (random 1 7))

  (for ([_ (in-range 3)])
    (define point (random 2 7))
    (cond
      [(>= point min)
       (set! total-point (+ total-point point))]
      [else
       (set! total-point (+ total-point min))
       (set! min point)]))
  total-point)

(define (modifier value)
  (floor (/ (- value 10) 2)))

(define (make-character)
  (define constitution (ability))
  (character (ability)
              (ability)
              constitution
              (ability)
              (ability)
              (ability)
              (+ 10 (modifier constitution))))
