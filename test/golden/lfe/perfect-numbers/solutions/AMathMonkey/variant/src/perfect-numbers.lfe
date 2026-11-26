(defmodule perfect-numbers
  (export (classify 1)))

(defun aliquot-sum (n)
  (lists:sum 
    (lc ((<- cand (lists:seq 1 (- n 1))) (== 1 (rem n cand))) 
      cand)))

(defun classify (n)
  (if (< n 1) 'false
    (let ((aliquot-sum (aliquot-sum n)))
      (cond
        ((< aliquot-sum n) 'deficient)
        ((> aliquot-sum n) 'abundant)
        ('true 'perfect)))))
