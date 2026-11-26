(defpackage :lucys-magnificent-mapper
  (:use :cl)
  (:export :make-magnificent-maybe :only-the-best))

(in-package :lucys-magnificent-mapper)

;; Define make-magnificent-maybe function
(defun make-magnificent-maybe (fn number-list)
  (mapcar fn number-list))
;; Define only-the-best function
(defun only-the-best (test number-list)
  (let ((modified-list (remove 1 number-list)))
    (remove-if test modified-list)))
