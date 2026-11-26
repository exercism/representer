(defpackage :logans-numeric-partition
  (:use :cl)
  (:export :categorize-number :partition-numbers))

(in-package :logans-numeric-partition)

(defun categorize-number (pair-of-lists number)
  (let ((odd-numbers (car pair-of-lists))
        (even-numbers (cdr pair-of-lists)))
    (if (evenp number)
        (cons odd-numbers (cons number even-numbers))
        (cons (cons number odd-numbers) even-numbers))))

(defun partition-numbers (list-of-numbers)
  (reduce #'categorize-number list-of-numbers :initial-value (cons () ())))
