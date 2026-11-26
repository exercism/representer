(defmodule collatz-conjecture
  (export (steps 1)))

(defun steps (n)
  (steps_helper n 0))


(defun steps_helper 
  ((input _acc) (when (=< input 0)) (error 'input-zero-or-negative))
  ((input acc) (when (== input 1)) acc)
  ((input acc) (cond ( (== 1 (rem input 2)) (steps_helper (+ (* 3 input ) 1) (+ acc 1)) )
        ('true (steps_helper (div input 2) (+ acc 1)))))
    )
