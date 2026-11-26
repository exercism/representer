(define (anagram target words)
  (let* ((k (make-vector 100 'a)) (n 1))
    (for-each (lambda (i) (if (not (equal? (string-downcase i)
					   (string-downcase target)))
				    (if (equal? (sort-list
						 (map char->integer (string->list (string-downcase i))) >)
						(sort-list 
						 (map char->integer (string->list (string-downcase target))) >))
					(begin (vector-set! k n i)
					       (set! n (+ n 1))))))
	      words)
    (delete! 'a (vector->list k))))
