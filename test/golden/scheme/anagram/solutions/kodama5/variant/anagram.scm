(import (rnrs))

(define (down_sorted word)
  (list->string (sort  char<=? (string->list (string-downcase word)))))

(define (anagram target words)
  (let ((target_down_sorted (down_sorted target) )) 
    (filter (lambda (w) (or (not (string=? (string-downcase target) (string-downcase w))) (string=? target_down_sorted (down_sorted w)))) words)))

