(defpackage :logans-numeric-partition
  (:use :cl)
  (:export :categorize-number :partition-numbers))

(in-package :logans-numeric-partition)

;; Define categorize-number function
(defun categorize-number (lists number)
  (if (oddp number)
      (cons (cons number (car lists)) (cdr lists))
      (cons (car lists) (cons number (cdr lists)))
      )
  )

;; Define partition-numbers function
(defun partition-numbers (list)
  (reduce #'categorize-number list :initial-value '(nil))
  )
