(defmodule queen-attack
  (export (create 3)
          (can-attack 2)))

(defun create (x y)
  (andalso (>= x 0) (=< x 7) (>= y 0) (=< y 7) (tuple x y)))

(defun can-attack
  (((tuple x1 y1) (tuple x2 y2))
   (orelse (== x1 x2) (== y1 y2) (== (abs (- x1 x2)) (abs (- y1 y2))))))
