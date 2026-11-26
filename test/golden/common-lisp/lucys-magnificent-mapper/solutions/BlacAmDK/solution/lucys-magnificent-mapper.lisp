(defpackage :lucys-magnificent-mapper
  (:use :cl)
  (:export :make-magnificent-maybe :only-the-best))

(in-package :lucys-magnificent-mapper)

;; Define make-magnificent-maybe function
(defun make-magnificent-maybe (fn arg)
  (mapcar fn arg))

;; Define only-the-best function
(defun only-the-best (fn arg)
  (remove 1 (remove-if fn arg)))
