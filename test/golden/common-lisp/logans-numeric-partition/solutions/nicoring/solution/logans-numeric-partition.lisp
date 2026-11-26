(defpackage :logans-numeric-partition
  (:use :cl)
  (:export :categorize-number :partition-numbers))

(in-package :logans-numeric-partition)

;; Define categorize-number function

(defun categorize-number (acc num)
  (if (oddp num)
      (cons (cons num (car acc)) (cdr acc))
      (cons (car acc) (cons num (cdr acc)))))

;; Define partition-numbers function

(defun partition-numbers (numbers)
  (reduce #'categorize-number numbers :initial-value '(())))