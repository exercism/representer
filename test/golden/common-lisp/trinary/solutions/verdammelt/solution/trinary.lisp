(defpackage #:trinary
  (:use #:common-lisp)
  (:export #:to-decimal))

(in-package #:trinary)

(defun to-decimal (str)
  (or (parse-integer str :radix 3 :junk-allowed t) 0))