(defmodule anagram
  (export (find 2)))

; Convert a word to a lowercase sorted list of characters
(defun to-lower-sorted-list (word)
  (lists:sort (string:to_lower word)))

; Find anagrams of a given word from a list of words
(defun find (word words)
  (let ((sorted-word (to-lower-sorted-list word)))
    ; Filter the list of words, keeping the candidate words
    (lists:filter
      (lambda (candidate)
        ; Check if the candidate is not the same word (case insensitive)
        ; and if the sorted characters match the sorted characters of the input word
        (and
          (not (== (string:to_lower word) (string:to_lower candidate)))
          (== sorted-word (to-lower-sorted-list candidate))))
      words)))
