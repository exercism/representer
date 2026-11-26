(defmodule anagram
  (export (find 3)))

(defun find (base candidates)
  "Return all candidates that are anagrams of, but not equal to, base. Comparisons are case insensitive."
  (let ((upper-base (string:to_upper base))
        (sorted-base (lists:sort (string:to_upper base))))
    (lists:filter
      (lambda (word)
        (let ((upper-word (string:to_upper word)))
          (and (/= upper-word upper-base)
               (== (lists:sort upper-word) sorted-base))))
      candidates)))
