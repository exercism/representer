(defmodule anagram
  (export (find 3)))

(defun find (word poss-anagrams)
  (let ([sorted-word (lists:sort (string:to_lower word))])
    (lists:filter (lambda (anag)
		    (and 
		     (== sorted-word (lists:sort (string:to_lower anag)))
		     (not (== (string:to_lower word) (string:to_lower anag)))))
		  poss-anagrams)))