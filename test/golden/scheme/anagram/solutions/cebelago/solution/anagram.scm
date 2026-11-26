(import (rnrs))
(use-modules (srfi srfi-1))

(define (anagram target words)
  (let* ((anagrams-alist '())
	(key (lambda (word) (sort (string-downcase word) char<?)))
	(anagrams (lambda (word) (or (assoc-ref anagrams-alist (key word))
				     '()))))
    (for-each
     (lambda (word)
	 (unless (member word (anagrams word) string-ci=?)
	   (set! anagrams-alist
		 (assoc-set! anagrams-alist
			     (key word) (cons word (anagrams word))))))
     words)
    (remove (lambda (anagram) (string-ci=? anagram target))
	    (anagrams target))))

