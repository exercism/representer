(defmodule two-fer
  (export (two-fer 1)))

(defun two-fer (name)
  (lists:concat
    `("One for " ,(if (string:is_empty name) "you" name) ", one for me.")))
