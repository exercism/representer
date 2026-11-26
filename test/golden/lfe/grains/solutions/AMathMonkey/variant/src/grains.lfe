(defmodule grains
  (export (square 1)
          (total 0)))

(defun square (n)
  (bsl 1 (- n 1)))

(defun total ()
  (lists:sum (lc ((<- n (lists:seq 2 64))) (square n))))
