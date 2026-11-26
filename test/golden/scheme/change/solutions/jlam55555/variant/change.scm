(import (rnrs))

; bottom-up dp approach to the coin change problem
(define (change amount coins)
  ; max-steps is used as the default length to any path, must be greater than
  ; the longest possible coin path (think of it as +Inf, which means that any
  ; path to a particular amount will replace this in min-counts)
  (define max-steps (1+ (quotient amount (apply min coins))))

  ; vector to hold dp data: holds the minimum number of coins and "path" data
  (define min-counts (make-vector (1+ amount) (cons max-steps 0)))

  ; backtrack once coin has been reached; gets coin "path"
  (define (backtrack)
    (if (= max-steps (car (vector-ref min-counts amount)))
        (error 'backtrack "no coin combination found")
        (let loop ([i amount]
                   [res `()])
          (define coin (cdr (vector-ref min-counts i)))
          (if (zero? i)
              res
              (loop (- i coin) (append res (list coin)))))))

  ; logic to update coins: update coin if this coin presents a path that
  ; is shorter than previous paths to that coin
  (define (update-vector i i-min-count)
    (lambda (coin)
      (when (or (<= (+ coin i)
                     amount)
                 (< (1+ i-min-count)
                    (car (vector-ref min-counts (+ coin i)))))
        (vector-set! min-counts
                     (+ coin i)
                     (cons (1+ i-min-count)
                     coin)))))

  ; base case
  (vector-set! min-counts 0 '(0 . 0))

  ; account for edge cases
  (if (and (< amount (car coins)) (not (zero? amount)))
      (error 'change "cannot make change for amount less than minimum coin")
      (let loop ([i 0])
        (define i-min-count (car (vector-ref min-counts i)))
        (if (= i amount)
          (backtrack)
          [begin
            (for-each
              (update-vector i i-min-count)
              coins)
            (loop (1+ i))]))))
