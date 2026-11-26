(defpackage :logans-numeric-partition
  (:use :cl)
  (:export :categorize-number :partition-numbers))

(in-package :logans-numeric-partition)

;; Define categorize-number function
(defun categorize-number (acc n)
  (if (oddp n)
       (cons (cons n (car acc)) (cdr acc))
       (cons (car acc) (cons n (cdr acc)))))

;; Define partition-numbers function
(defun partition-numbers (ns)
  (reduce #'categorize-number ns :initial-value (cons () ()) ))