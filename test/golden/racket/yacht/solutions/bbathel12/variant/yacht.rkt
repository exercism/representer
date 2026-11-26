#lang racket

(provide yacht)

(define STRAIGHT-SCORE 30)
(define YACHT-SCORE 50)

(define (four-of-a-kind? dice)
  (let ([sorted-dice (sort dice <)])
    (or (apply = (take sorted-dice 4)) (apply = (drop sorted-dice 1)))))

(define (full-house? dice)
  (let ([sorted-dice (sort dice <)])
    (and (not (apply = sorted-dice))
         (or (or (apply = (take sorted-dice 2)) (apply = (drop sorted-dice 2)))
             (and (apply = (take sorted-dice 3)) (apply = (drop sorted-dice 3)))))))

(define (yacht? dice)
  (apply = dice))

(define (little-straight? dice)
  (let ([sorted-dice (sort dice <)])
    (match sorted-dice
      [(list 1 2 3 4 5) #t]
      [else #f])))

(define (big-straight? dice)
  (let ([sorted-dice (sort dice <)])
    (match sorted-dice
      [(list 2 3 4 5 6) #t]
      [else #f])))

(define (little-straight-scorer dice)
  (if (little-straight? dice) STRAIGHT-SCORE 0))

(define (big-straight-scorer dice)
  (if (big-straight? dice) STRAIGHT-SCORE 0))

(define (full-house-scorer dice)
  (if (full-house? dice)
      (apply + dice)
      0))

(define (numbers-category? category)
  (and (member category (list "ones" "twos" "threes" "fours" "fives" "sixes")) #t))

(define (category->filter-number cat)
  (case cat
    [("ones") 1]
    [("twos") 2]
    [("threes") 3]
    [("fours") 4]
    [("fives") 5]
    [("sixes") 6]))

(define (score-numbers-category dice category)
  (apply + (filter (curry = (category->filter-number category)) dice)))

(define (score-four-of-a-kind dice)
  (let ([sorted-dice (sort dice <)])
    (if (four-of-a-kind? sorted-dice)
        (if (apply = (take sorted-dice 4))
            (apply + (take sorted-dice 4))
            (apply + (drop sorted-dice 1)))
        0)))

(define (yacht dice category)
  (cond
    [(numbers-category? category) (score-numbers-category dice category)]
    [(string=? category "choice") (apply + dice)]
    [(string=? category "four of a kind") (score-four-of-a-kind dice)]
    [(string=? category "big straight") (big-straight-scorer dice)]
    [(string=? category "little straight") (little-straight-scorer dice)]
    [(string=? category "full house") (full-house-scorer dice)]
    [(string=? category "yacht") (if (yacht? dice) YACHT-SCORE 0)]
    [else (error 'yacht "Expected a valid category given: ~a" category)]))

