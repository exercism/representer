(defmodule rna-transcription
  (export (to-rna 2)))

(defun to-rna (s)
  (lc ((<- c s))
    (case c
      (#\G #\C)
      (#\C #\G)
      (#\T #\A)
      (#\A #\U))))
