(import (rnrs)
        (srfi srfi-1))

#|
   Here's the idea:
   - We build a table that's got (1+ amount) columns and (length coins) rows
   - then, for each cell, we figure out the cheapest way to get there:
      - if we're at an amount that exactly corresponds to a coin, it's one step: use the coin
      - if the coin is bigger than the amount, we can't use the coin, we use the previous solution for this amount
      - if the amount is bigger than the coin, we have to choose which is better:
         - not using the current coin, i.e. going another path, or
         - using the coin, thereby increasing the path by one

   The solution is not LISPy at all, is basically directly lifted from
   https://en.wikipedia.org/wiki/Change-making_problem
   but it works.
|#
(define (table-builder amount coins)
  (let [(table (make-array +inf.0 (length coins) (1+ amount)))
        (c-lst (make-array #f     (length coins) (1+ amount)))]
    (map
      (lambda (c-ix)
        (map
          (lambda (r)
            (let* [(coin (list-ref coins c-ix))
                   (p-c (max (1- c-ix) 0)) ; the previous solution for making r, excluding coin
                   (p-r (max (- r coin) 0))] ; the previous solution without this coin, plus this coin
              (display (format #f "r: ~a, c: ~a, coin: ~a\n" r c-ix coin))
              (cond
                ;; we can use the coin, exactly
                [(= coin r)
                 (array-set! table 1        c-ix r)
                 (array-set! c-lst (list r) c-ix r)]
                ;; we cannot use the coin. Use previous solution for making r
                [(> coin r)
                 (array-set! table (array-ref table p-c r) c-ix r)
                 (array-set! c-lst (array-ref c-lst p-c r) c-ix r)]
                ;; we can use the coin, but not exactly
                [else
                  ;; which one is better? the current solution for r without the coin,
                  ;; or the solution for (- r coin) + coin?
                  (if (< (array-ref table p-c r)
                         (1+ (array-ref table c-ix p-r)))
                    ;; not using the coin is better
                    (begin
                      (array-set! table
                                  (array-ref table p-c r)
                                  c-ix
                                  r)
                      (array-set! c-lst
                                  (array-ref c-lst p-c r)
                                  c-ix
                                  r))
                    ;; using the coin is better
                    (begin
                      (array-set! table
                                  (1+ (array-ref table c-ix p-r))
                                  c-ix
                                  r)
                      (array-set! c-lst
                                  (append (list coin)
                                          (array-ref c-lst c-ix p-r))
                                  c-ix
                                  r)))])))
          (iota amount 1)))
      (iota (length coins)))
    (list table c-lst)))

;;; main
(define (change amount coins)
  (cond
    [(zero? amount) '()]
    [(< amount 0) (error "We can't give change for negative amounts." 'negative-amount)]
    [(< amount (apply min coins)) (error "We can't give change for an amount that's smaller than the smallest coin"
                                         'amount-too-small)]
    [else
      (let* [(l (table-builder amount coins))
             (table (first l))
             (c-lst (second l))
             (i (1- (length coins)))
             (cost (array-ref table i amount))]
        (if (inf? cost)
          (error "Can't figure out the change" 'unsolvable)
          (array-ref c-lst i amount)))]))

