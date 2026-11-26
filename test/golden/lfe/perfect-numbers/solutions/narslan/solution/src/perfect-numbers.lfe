(defmodule perfect-numbers
  (export (classify 1)))

(defun classify (number)
  (if (=< number 0)
      'false
      (let* 
        ((sum (aliquot_sum number)))
        (cond 
          ((< number sum ) 'abundant)
          ((> number sum ) 'deficient)
          ('true 'perfect)) 
        )))

(defun aliquot_sum (number)
  (let* ((stream (lists:seq 1 (trunc (/ number 2)))))
        (lists:foldl (lambda (x acc) (
          case (rem number x)
                (0 (+ acc x))
                (_ acc))) 0 stream)
        ))