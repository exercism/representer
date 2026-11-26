(defmodule anagram
  (export (find 2)))

(defun find (target words)
  (lists::filter (lambda (word) (and (not (equal? target word))
                                     (equal? (sort-chars target) (sort-chars word))))
                 words))

(defun equal? (word1 word2)
  (=:= (string::lowercase word1)
       (string::lowercase word2)))

(defun sort-chars (word)
  (lists::sort (string::lowercase word)))
