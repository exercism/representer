(defmodule trinary
  (export (to-decimal 1)))

(defun valid-trinary? (s)
  "True if s is a list of chars and every char is one of '0','1','2'."
  (andalso (is_list s)
           (lists:all (lambda (c) (lists:member c "012")) s)))

(defun to-decimal (s)
  "Convert a trinary string to its decimal value; invalid strings map to 0."
  (case (valid-trinary? s)
    ('true
     ;; Accumulate left-to-right: acc*3 + digit
     (lists:foldl
       (lambda (c acc)
         (+ (* acc 3)
            (- c (hd "0"))))   ;; '0' -> 48; c - 48 gives digit value
       0
       s))
    (_ 0)))
    