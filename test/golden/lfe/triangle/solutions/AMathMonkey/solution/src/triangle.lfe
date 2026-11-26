(defmodule triangle
  (export (kind 3)))

;; The problem description says degenerate triangles won't be tested
;; but there is a test for a degenerate triangle (1 2 3) and it must be deemed invalid
(defun valid (a b c)
  (andalso 
    (> a 0) (> b 0) (> c 0)
    (> (+ a b) c) (> (+ b c) a) (> (+ a c) b)))

(defun kind (a b c)
  (andalso (valid a b c)
    (cond
      ((andalso (== a b) (== b c)) 'equilateral)
      ((orelse (== a b) (== b c) (== a c)) 'isosceles)
      ('true 'scalene))))
