#lang racket

(require racket/hash)

(provide word-count)

(define (counts-of words)
  (let aux ([words words] [acc (hash)])
    (if (empty? words)
        acc
        (aux
          (rest words)
          (hash-union acc
                      (hash (first words) 1)
                      #:combine/key (lambda (k v1 v2) (+ v1 v2)))))))

(define (word-count phrase)
  (let* ([words
           (filter non-empty-string?
                   (regexp-split #px"[?,;:[:space:]]+" phrase))]
         [lower-cased (map string-downcase words)]
         [tidied
           (filter non-empty-string?
             (map (lambda (s) (string-trim s #px"[^[:alnum:]]+"))
                  lower-cased))])
    (counts-of tidied)))
