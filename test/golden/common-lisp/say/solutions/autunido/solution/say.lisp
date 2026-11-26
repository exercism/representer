(defpackage :say
  (:use :cl)
  (:export :say))

(in-package :say)

;; There are many languages that do not have ~R, so I'll do it myself in one of those
(defun say (number)
  (when
      (<= 0 number 999999999999)
    (format nil "~R" number)))
