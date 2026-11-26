(defpackage :hamming
  (:use :cl)
  (:export :distance))

(in-package :hamming)

(defun distance (strand1 strand2)
  (when (eq (length strand1) (length strand2))
    (count-if-not #'identity (map 'list #'char= strand1 strand2))))
