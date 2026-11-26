#lang racket

(provide (struct-out character)
         ability
         make-character
         modifier)

(struct character
    (hitpoints
     constitution
     strength
     dexterity
     intelligence
     wisdom
     charisma))

(define (ability)
  (let ([throws (for/list ([i 4]) (random 1 7))])
    (- (apply + throws) (apply min throws))))

(define (modifier value)
  (floor (/ (- value 10) 2)))

(define (make-character)
  (apply character
         (let ([abilities (build-list 6 (λ (_) (ability)))])
           (cons (+ 10 (modifier (car abilities))) abilities))))

