(defmodule anagram
  (export (find 2)))

(defun find (base candidates)
  (let* ((base-down (string:to_lower base))
         (sorted-base (sort-letters base-down)))
    (lists:filter
     (lambda (candidate)
       (let* ((cand-down (string:to_lower candidate))
              (sorted-cand (sort-letters cand-down)))
         (and
          (not (== cand-down base-down))
          (== sorted-cand sorted-base))))
     candidates)))

(defun sort-letters (word)
  (let* ((graphemes (string:to_graphemes word))
         (sorted (lists:sort graphemes)))
    sorted))