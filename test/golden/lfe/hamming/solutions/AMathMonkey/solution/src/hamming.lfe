(defmodule hamming
  (export (distance 2)))

(defun distance
  [(s1 s2) (when (== (length s1) (length s2))) (distance s1 s2 0)]
  [(_ _) (error 'badarg)])

(defun distance 
  [('() '() acc) acc]
  [((cons x r1) (cons x r2) acc) (distance r1 r2 acc)]
  [((cons _ r1) (cons _ r2) acc) (distance r1 r2 (+ acc 1))])
