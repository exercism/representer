(defmodule raindrops
    (export (convert 1)))

(defun convert (n)
  (let*
    ((mappings '((3 . "Pling") (5 . "Plang") (7 . "Plong")))
     (res
       (lists:concat
         (lc
           ((<- (cons i s) mappings)
            (== 0 (rem n i)))
          s))))
    (if (string:is_empty res) (integer_to_list n) res)))
