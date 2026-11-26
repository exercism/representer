(defpackage :logans-numeric-partition
  (:use :cl)
  (:export :categorize-number :partition-numbers))

(in-package :logans-numeric-partition)

(defun categorize-number (storage n)
  (if (oddp n)
      (cons (cons n (car storage)) (cdr storage))
      (cons (car storage) (cons n (cdr storage)))))

(defun partition-numbers (numbers)
  (reduce #'categorize-number numbers :initial-value (cons nil nil)))
