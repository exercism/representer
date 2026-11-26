(defmodule all-your-base
  (export (rebase 3)))

(defun to-base10 (digits input-base)
  (lists:foldl 
    (match-lambda (((tuple i d) sum) (when (>= d 0) (< d input-base))
      (+ sum (* d (trunc (math:pow input-base i))))))
    0 
    (lists:enumerate 0 (lists:reverse digits))))

(defun to-base (n base)
  (letrec-function 
    ((loop (lambda (n acc)
      (if (== 0 n) (if (== acc '()) '(0) acc)
        (loop (div n base) (cons (rem n base) acc))))))
    (loop n '())))

(defun rebase 
  ((input-base digits output-base) (when (and (>= input-base 2) (>= output-base 3)))
    (to-base (to-base10 digits input-base) output-base)))
