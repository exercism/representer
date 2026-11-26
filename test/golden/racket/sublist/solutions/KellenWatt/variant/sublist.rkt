#lang racket

(provide sublist?)

(define (starts-with? l l-size sub sub-size)
  (if (< l-size sub-size) 
    #f
    (if (empty? sub)
      #f
      (if (eq? (first l) (first sub)) (starts-with? (rest l) (sub1 l-size) (rest sub) (sub1 sub-size)) #f))))

(define (contains? l l-size sub sub-size)
  (if (< l-size sub-size)
    #f
    (if (starts-with? l l-size sub sub-size) #t (contains? (rest l) (sub1 l-size) sub sub-size))))

(define (sublist? s l)
  (let ([slen (length s)]
        [llen (length l)])
    (cond
      [(and (= slen llen) (equal? s l)) 'equal]
      [(and (slen . < . llen) (contains? l llen s slen)) 'sublist]
      [(and (slen . > . llen) (contains? s slen l llen)) 'superlist]
      [else 'unequal])))
