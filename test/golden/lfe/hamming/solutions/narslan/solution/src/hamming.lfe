(defmodule hamming
  (export (distance 2)))

(defun distance (dna1 dna2)
  (cond 
    ((== (length dna1) (length dna2) ) 
      (let* ((zipped (lists:filter (lambda (x) x) (lists:zipwith (lambda (x y) (not (== x y))) dna1 dna2))))
        (length zipped)
      )) 
    ( 'true (error "strands must be of equal length") ))
  )