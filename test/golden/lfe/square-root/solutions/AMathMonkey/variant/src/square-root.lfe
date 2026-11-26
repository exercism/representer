(defmodule square-root
  (export (calculate 2)))

(defun calculate (n)
  (fletrec ((loop (i) (if (== (* i i) n) i (loop (+ 1 i)))))
    (loop 1)))
