(defmodule line-up
  (export (format 2)))

(defun format (name n)
  (lists:concat `(,name ", you are the " ,n ,(ordinal n) " customer we serve today. Thank you!")))

(defun ordinal (n)
  (case (tuple (rem n 100) (rem n 11))
    ((tuple x _) (when (and (>= x 11) (=< x 13))) "th")
    ((tuple _ 1) "st")
    ((tuple _ 2) "nd")
    ((tuple _ 3) "rd")
    (_ "th")))
