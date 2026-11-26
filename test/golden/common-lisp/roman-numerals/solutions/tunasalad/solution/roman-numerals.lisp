(defpackage :roman-numerals
  (:use :cl)
  (:export :romanize))

(in-package :roman-numerals)

(defparameter roman-values
  '((1000 . M)
    ( 900 . CM) (500 . D) (400 . CD) (100 . C)
    (  90 . XC) ( 50 . L) ( 40 . XL) ( 10 . X)
    (   9 . IX) (  5 . V) (  4 . IV) (  1 . I)))

(defun romanize (number)
  "Returns the Roman numeral representation for a given number."
  (loop with n = number
        and pairs = roman-values

        while pairs

        for p = (car pairs)
        for val = (car p)
        for name = (symbol-name (cdr p))

        if (>= n val)
        do (decf n val) and collect name into result
        else
        do (pop pairs)
        end

        finally (return (apply #'concatenate 'string result))))
