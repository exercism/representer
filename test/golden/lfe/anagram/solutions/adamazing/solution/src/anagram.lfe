(defmodule anagram
  (export (find 2)))

(defun compare (a)
  (lambda (b)
    (and  (=:=  (lists:sort (string:to_lower a))
                (lists:sort (string:to_lower b)))
          (=/=  (string:to_lower a)
                (string:to_lower b))
    )
  )
)

(defun find (needle haystack)
  (lists:filter (compare needle) haystack)
)

