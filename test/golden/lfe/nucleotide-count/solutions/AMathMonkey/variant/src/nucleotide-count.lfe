(defmodule nucleotide-count
  (export (counts 2)))

(defun counts (s)
  (lc ((<- (tuple c v) 
         (maps:to_list
           (lists:foldl 
             (lambda (c acc) (maps:update_with c (lambda (v) (+ 1 v)) acc))
             (maps:from_list (lc ((<- c "AGCT")) (tuple c 0)))
             s))))
  (tuple (list c) v)))
