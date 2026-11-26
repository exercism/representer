;; The tests expect different module and function names than what the exercise
;; comes pre-populated with. That needs to be fixed.
;; (defmodule reverse-string
;;     (export (reverse 1)))

(defmodule reverse
    (export (string 2)))

(defun
  ;; reverse ;; This name doesn't work
  string (s)
  (lists:foldl (lambda (c acc) (cons c acc)) "" s))
