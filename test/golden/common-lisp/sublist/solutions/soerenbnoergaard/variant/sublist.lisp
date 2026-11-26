(defpackage #:sublist
  (:use #:common-lisp)
  (:export #:sublist))

(in-package #:sublist)

(defun sublist-p (list1 list2)
  (not (null (search list1 list2))))

(defun superlist-p (list1 list2)
  (sublist-p list2 list1))

(defun equal-p (list1 list2)
  (or (sublist-p list1 list2)
       (superlist-p list1 list2)))

(defun sublist (list1 list2)
  "what is list1 of list2 (sublist, superlist, equal or unequal)"
  (cond ((equal-p list1 list2) :equal)
        ((sublist-p list1 list2) :sublist)
        ((superlist-p list1 list2) :superlist)
        (t :unequal)))
