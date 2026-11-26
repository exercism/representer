(defmodule series
  (export (from-string 2)))

(defun from-string (n s)
  (let ((len (length s)))
    (if (not (andalso (>= n 1) (=< n len))) (error "invalid input"))
    (lc ((<- start (lists:seq 1 (- len n -1))))
      (lists:sublist s start n))))
