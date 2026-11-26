(defpackage :logans-numeric-partition
  (:use :cl)
  (:export :categorize-number :partition-numbers))

(in-package :logans-numeric-partition)

;; Define categorize-number function
(defun categorize-number (categories x)
  (if (oddp x) 
      (cons (cons x (car categories)) (cdr categories))
      (cons (car categories) (cons x (cdr categories)))))

;; Define partition-numbers function
(defun partition-numbers (xs)
  (reduce #'categorize-number xs :initial-value '(nil)))