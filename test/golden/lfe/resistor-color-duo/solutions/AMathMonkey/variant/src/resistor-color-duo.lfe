(defmodule resistor-color-duo
  (export (value 1)))

(defun value 
  (((list* tens ones _))
    (let ((colors 
           '("black" "brown" "red" "orange" "yellow"
             "green" "blue" "violet" "grey" "white")))
      (+ (* 11 (cl:position tens colors)) (cl:position ones colors)))))
