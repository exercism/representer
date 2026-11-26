(defmodule high-scores
  (export (latest 1)
          (personal-best 1)
          (personal-top-three 1)))

; Please implement the exported function(s).

(defun latest (l)
  (cl:last l)
  )

(defun personal-best (l)
  (cl:last (lists:sort l))
  )

(defun personal-top-three (l)
  (lists:sublist (lists:reverse (lists:sort l)) 3) )