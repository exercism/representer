(defpackage #:strain
  (:use #:common-lisp)
  (:export #:keep #:discard))

(in-package #:strain)

(defun keep (condition items)
  (remove-if-not condition items))

(defun discard (condition items)
  (remove-if condition items))
