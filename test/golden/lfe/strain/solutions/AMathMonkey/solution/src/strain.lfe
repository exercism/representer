(defmodule strain
  (export (keep 2)
          (discard 2)))

(defun keep (pred list)
  (lc ((<- elem list) (funcall pred elem)) elem))

(defun discard (pred list)
  (keep (lambda (elem) (not (funcall pred elem))) list))
