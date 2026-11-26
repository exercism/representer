(defmodule acronym
  (export (abbreviate 2)))

(defun abbreviate (s)
  (let* (
         (words (string:lexemes s " -_"))
         (initials (lists:map
                     (lambda (w)
                       (string:substr w 1 1))
                     words))
         (joined (string:join initials ""))

         (upper (string:to_upper joined)))
    upper))
