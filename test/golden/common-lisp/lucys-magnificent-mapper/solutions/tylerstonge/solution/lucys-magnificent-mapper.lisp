(defpackage :lucys-magnificent-mapper
  (:use :cl)
  (:export :make-magnificent-maybe :only-the-best))

(in-package :lucys-magnificent-mapper)

;; Define make-magnificent-maybe function
(defun make-magnificent-maybe (fun list)
  (mapcar fun list))

;; Define only-the-best function
(defun only-the-best (fun list)
  (remove-if fun (remove 1 list)))
