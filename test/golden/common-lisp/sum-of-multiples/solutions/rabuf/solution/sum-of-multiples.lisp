(defpackage :sum-of-multiples
  (:use :cl)
  (:export :sum))

(in-package :sum-of-multiples)

(defun sum (factors limit)
  (loop for i from 1 below limit
        when (is-factor-of factors i)
        sum i))

(defun is-factor-of (factors n)
  (loop for f in factors
        when (and (not (zerop f)) (zerop (mod n f)))
        return 't))
