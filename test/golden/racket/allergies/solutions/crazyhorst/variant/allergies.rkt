#lang racket

(provide allergic-to? list-allergies)

(define allergies
  (hash "eggs" 0
        "peanuts" 2
        "shellfish" 2
        "strawberries" 3
        "tomatoes" 4
        "chocolate" 5
        "pollen" 6
        "cats" 7))

(define (allergic-to? allergen score)
  (bitwise-bit-set? score (hash-ref allergies allergen)))

(define (list-allergies score)
  (filter (λ (allergen) (allergic-to? allergen score))
          (hash-keys allergies)))