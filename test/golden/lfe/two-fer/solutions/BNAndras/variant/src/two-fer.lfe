(defmodule two-fer
  (export (two-fer 2)))

(defun two-fer
    (("") "One for you, one for me.")
    ((name) (++ "One for " name ", one for me."))) 