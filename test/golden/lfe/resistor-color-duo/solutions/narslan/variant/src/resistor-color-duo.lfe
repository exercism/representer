(defmodule resistor-color-duo
  (export (value 2)
	  (undigits 1)
	  ))

(defun value (resistor)
  (let ((res1 (color-code (car resistor)  ) )
	(res2 (color-code (cadr resistor) ) )	)
    (undigits   (list res1 res2) )) )

(defun undigits (digits)
  (fletrec ((undigit-loop
	     ([(cons digit rest) acc] (undigit-loop rest (+ digit (* acc 10))) )
	     ([() acc] acc )
	     ))
    (undigit-loop digits 0)))

(defun color-code (color)
  (cl:position color (colors)) )


(defun colors ()
  '("black"
    "brown"
    "red"
    "orange"
    "yellow"
    "green"
    "blue"
    "violet"
    "grey"
    "white" ))