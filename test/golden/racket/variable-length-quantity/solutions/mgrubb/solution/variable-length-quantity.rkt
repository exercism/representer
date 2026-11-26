#lang racket

(provide encode decode)

(define-syntax-rule (1+ x) (+ 1 x))

(define (encode1 num)
  (letrec ([encode-byte (lambda (byte pos)
                          (let ([low (bitwise-and byte #x7F)]
                                [high (if (> pos 0)
                                        #x80
                                        #x00)])
                            ;(arithmetic-shift
                            ;  (bitwise-ior low high) (* pos 8))
                            (bitwise-ior low high)))]
           [loop (lambda (byten num acc)
                   (if (= num 0)
                     acc
                     (loop
                       (1+ byten)
                       (arithmetic-shift num -7)
                       (cons (encode-byte num byten) acc))))])
    (cond
      [(< num 128) num]
      [else (loop 0 num '())])))

(define (encode . nums)
  (flatten (map encode1 nums)))

;; Chunks a list by a predicate but also includes the first failing item in each chunk
(define (chunk-by lst pred)
  (letrec ([collect (lambda (lst pred acc tmp)
                      (cond
                        [(empty? lst) (reverse (if (empty? tmp)
                                                 acc
                                                 (cons tmp acc)))]
                        [(pred (car lst)) (collect (cdr lst) pred acc (cons (car lst) tmp))]
                        [else (collect
                                (cdr lst)
                                pred
                                (cons (reverse (cons (car lst) tmp)) acc)
                                '())]))])
    (collect lst pred '() '())))



(define (decode1 bytes)
  (letrec ([rbytes (reverse bytes)]
           [decode-byte (lambda (byte pos)
                          (arithmetic-shift (bitwise-and byte #x7F) (* 7 pos)))]
           [loop (lambda (pos bytes acc)
                   (if (empty? bytes)
                     acc
                     (loop (1+ pos) (cdr bytes) (bitwise-ior acc (decode-byte (car bytes) pos)))
                   ))])
    (if (or (empty? bytes) (= #x80 (bitwise-and (car rbytes) #x80)))
      (error "invalid sequence")
      (loop 0 rbytes 0))))

(define (decode . nums)
  (let ([enc-bytes (chunk-by nums (lambda (x) (= #x80 (bitwise-and x #x80))))])
    (map decode1 enc-bytes)))
