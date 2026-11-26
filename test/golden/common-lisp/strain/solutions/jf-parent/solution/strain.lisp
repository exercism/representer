(defpackage #:strain
  (:use #:common-lisp)
  (:export #:keep #:discard))

(in-package #:strain)

(defun keep (predicate collection)
  (remove-if-not predicate collection))

(defun discard (predicate collection)
  (remove-if predicate collection))
