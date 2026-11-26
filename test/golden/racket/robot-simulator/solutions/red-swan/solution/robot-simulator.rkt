#lang racket

(provide robot%)

(define robot%
  (class object%
    (super-new)
    
    (init-field [position  '(0 0)]
                [direction 'north])

    (define (turn! dir)
      (match (list direction dir)
        [(or (list 'west 'right)  (list 'east 'left))
         (set! direction 'north)]
        [(or (list 'east 'right)  (list 'west 'left))
         (set! direction 'south)]
        [(or (list 'south 'right) (list 'north 'left))
         (set! direction 'west)]
        [(or (list 'north 'right) (list 'south 'left))
         (set! direction 'east)]))
        
    (define (advance!)
      (match (list position direction)
        [(list (list x y) 'east)  (set! position (list (add1 x) y))]
        [(list (list x y) 'west)  (set! position (list (sub1 x) y))]
        [(list (list x y) 'south) (set! position (list x (sub1 y)))]
        [(list (list x y) 'north) (set! position (list x (add1 y)))]))
    
    (define/public (command! char)
      (match char
        [#\R (turn! 'right)]
        [#\L (turn! 'left)]
        [#\A (advance!)]
        [_ (error "Bad command: ~a")]))
        
    (define/public (move directions)
      (for ([c (string->list directions)])
        (command! c)))

    ))



