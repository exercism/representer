#lang racket

(provide etl)

(define/contract (etl mapping)
  (-> (hash/c positive? (listof string?)) hash?)
  (for*/hash ([(k vs) (in-hash mapping)]
              [v vs])
    (values (string-upcase v) k)))