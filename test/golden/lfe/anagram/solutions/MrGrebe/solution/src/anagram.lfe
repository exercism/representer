(defmodule anagram
  (export (find 2)))



(defun find (u wlist)
  (let ((su (lists:sort (string:to_upper u))))
  (lists:filter (lambda (x) (and (/= (string:to_upper u) (string:to_upper x)) (== su (lists:sort (string:to_upper x))))) wlist) 
  )
)
