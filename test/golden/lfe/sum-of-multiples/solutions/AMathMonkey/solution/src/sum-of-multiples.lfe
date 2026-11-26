(defmodule sum-of-multiples
  (export (sum-of-multiples 2)))

(defun sum-of-multiples (nums limit)
  (recur nums limit 0 0))

(defun recur (nums limit sum i)
  (cond
    [(== i limit) sum]
    [(cl:some (lambda (x) (== 0 (rem i x))) nums) (recur nums limit (+ sum i) (+ 1 i))]
    ['true (recur nums limit sum (+ 1 i))]))
