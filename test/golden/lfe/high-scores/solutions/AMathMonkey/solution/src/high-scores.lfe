(defmodule high-scores
  (export (latest 1)
          (personal-best 1)
          (personal-top-three 1)))

(defun latest (scores)
  (lists:last scores))

(defun personal-best (scores)
  (lists:max scores))

(defun personal-top-three (scores)
  (lists:sublist (lists:sort (lambda (a b) (< b a)) scores) 3))
