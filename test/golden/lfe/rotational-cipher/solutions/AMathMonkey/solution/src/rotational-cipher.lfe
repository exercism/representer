(defmodule rotational-cipher
  (export (rotate 2)))

(defun rotate (s n)
  (lc ((<- c s))
    (let 
      ((base 
         (cond
           ((andalso (>= c #\a) (=< c #\z)) #\a)
           ((andalso (>= c #\A) (=< c #\Z)) #\A)
           ('true 'false))))
      (if (== base 'false) c (+ (rem (+ (- c base) n) 26) base)))))
