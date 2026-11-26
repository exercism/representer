(import (rnrs))


(define (anagram target words)
  (let* ((string->sorted-list
	  (lambda (s)
	    (sort char<? (string->list (string-downcase s)))))
	 (target (string-downcase target))
	 (target-list (string->sorted-list target)))
    (filter (lambda (w)
	      (and (not (string=? (string-downcase w) target))
		   (equal? (string->sorted-list w)
			   target-list)))
	    words)))