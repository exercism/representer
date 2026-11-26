#lang racket

(provide encode decode)

;;; Both of these should expect to take a variable number of arguments.
;;; You may wish to make a version that accepts a single argument first
;;; as that will make debugging easier.
(define (encode-single num)
  (let* ([str (number->string num 2)]
         [lst (for/list ([i (range (string-length str) 0 -7)])
                (let ([start (max 0 (- i 7))])
                  (substring str start i)))]
         [lst1 (reverse lst)]
         [lst2 (map (λ (x) (string->number x 2)) lst1)])
    (for/list ([n lst2] [i (range (length lst2))])
      (if (< i (sub1 (length lst2))) (+ 128 n) n))))
        

(define (encode . nums)
  (flatten (map encode-single nums)))
                         
;; Function to split a list into sublists of a specific size
(define (split-list-into-chunks lst chunk-sizes)
  (if (null? lst)
      '()
      (cons (take lst (first chunk-sizes))
            (split-list-into-chunks (drop lst (first chunk-sizes)) (rest chunk-sizes)))))

(define (find-numbers nums count)
  (cond
    [(null? nums) (list)]
    [(< (first nums) 128) (cons (add1 count) (find-numbers (rest nums) 0))]
    [else (find-numbers (rest nums) (add1 count))]))

(define (decode . nums)
      (map decode-single (split-list-into-chunks nums (find-numbers nums 0))))


(define (decode-single nums)
  (if
   (> (last nums) 127)
      (error "Invalid number format")
      (let* ([str1 (map (λ (n) (if (> n 127) (number->string n 2) (number->string (+ 128 n) 2))) nums)]
             [str2 (map (λ (s) (substring s 1)) str1)]
             [result (foldr string-append "" str2)])
        (string->number result 2))))


