(defpackage :lucys-magnificent-mapper
  (:use :cl)
  (:export :make-magnificent-maybe :only-the-best))

(in-package :lucys-magnificent-mapper)

(defun make-magnificent-maybe (f l)
  (mapcar f l))

(defun only-the-best (f l)
  (remove-if f (remove 1 l)))