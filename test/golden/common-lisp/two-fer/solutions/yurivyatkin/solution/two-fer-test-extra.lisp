;;;
;;; two-fer v1.2.0
;;;
(ql:quickload "lisp-unit")
#-xlisp-test (load "two-fer")

(defpackage #:two-fer-test
  (:use #:common-lisp #:lisp-unit))
(in-package #:two-fer-test)

;;; Testing for non-string inputs

(define-test
    name-given-number
    (assert-equal
     "One for you, one for me."
     (two-fer:twofer 123)))

(define-test
    name-given-list
    (assert-equal
     "One for you, one for me."
     (two-fer:twofer '(1 2 3))))

#-xlisp-test
(let ((*print-errors* t)
      (*print-failures* t))
  (run-tests :all))
