(defmodule acronym
  (export (abbreviate 1)))

(defun abbreviate (phrase)
  (go phrase 'true 'false '()))

(defun go
  (('() _new-word _saw-uppercase acc)
    (lists:reverse acc))
  (((cons c rest) new-word saw-uppercase acc)
    (cond
      ((orelse (=:= c #\ ) (=:= c #\-) (=:= c #\_))
       (go rest 'true 'false acc))
      ((andalso (>= c #\a) (=< c #\z))
       (if new-word
           (go rest 'false 'false (cons (- c 32) acc))
           (go rest new-word 'false acc)))
      ((andalso (>= c #\A) (=< c #\Z))
       (if (or new-word (not saw-uppercase))
           (go rest 'false 'true (cons c acc))
           (go rest new-word saw-uppercase acc)))
      ('true
       (go rest 'false 'false acc)))))
