(defmodule difference-of-squares
  (export (square-of-sum 1)
          (sum-of-squares 1)
          (difference-of-squares 1)))

; Please implement the exported function(s).
(defun sum-of-squares (n)
  (lists:foldl (lambda (x acc) (+ (* x x) acc)) 0 (lists:seq 1 n))
  )

(defun square-of-sum (n)
  (trunc (math:pow (lists:foldl (lambda (x acc) (+ x acc)) 0 (lists:seq 1 n)) 2))
  )

(defun difference-of-squares (n)
  (- (square-of-sum n) (sum-of-squares n) )
  )

