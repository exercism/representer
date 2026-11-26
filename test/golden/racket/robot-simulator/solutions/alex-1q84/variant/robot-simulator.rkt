#lang racket

(provide robot%)

(define robot%
  (class object%
    (init-field position direction)
    (super-new)

;; 定义四个方向，按顺序排列，这样如果我们知道当前方向的位置就能通过该位置的前一个或后一个元素指出向左转或向右转到方向
;; 再定义四个前进方向所对应的单位坐标改变

    (define directions #(north east south west))
    (define dir-pos-map
      (for/fold ([m (hash)] [pos 0] #:result m) ([d (in-vector directions)])
        (values (hash-set m d pos) (add1 pos))))
    
    (define (turn lr)
      (match lr
        [#\L (vector-ref directions (modulo (sub1 (hash-ref dir-pos-map direction)) 4))]
        [#\R (vector-ref directions (modulo (add1 (hash-ref dir-pos-map direction)) 4))]))

    (define (move-ahead pos dir)
      (match dir
        ['north `(,(+ (first pos) 0) ,(+ (second pos) 1))]
        ['east `(,(+ (first pos) 1) ,(+ (second pos) 0))]
        ['south `(,(+ (first pos) 1) ,(+ (second pos) -1))]
        ['west `(,(+ (first pos) -1) ,(+ (second pos) 0))]))
    
    (define/public (move directions)
      (for ([d (in-string directions)])
        (match d
          [#\L (set! direction (turn d))]
          [#\R (set! direction (turn d))]
          [#\A (set! position (move-ahead position direction))])))
    ))