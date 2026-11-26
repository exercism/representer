(defpackage :logans-numeric-partition
  (:use :cl)
  (:export :categorize-number :partition-numbers))

(in-package :logans-numeric-partition)

(defun categorize-number (pair n)
  (if (oddp n)
      (cons (cons n (car pair)) (cdr pair))
      (cons (car pair) (cons n (cdr pair)))))

;; Define partition-numbers function
(defun partition-numbers (numbers)
  (reduce #'categorize-number numbers :initial-value (cons nil nil)))
