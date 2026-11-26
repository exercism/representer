(defpackage :sublist
  (:use :cl)
  (:export :sublist))

(in-package :sublist)

(defun sublist (list1 list2)
  "what is list1 of list2 (sublist, superlist, equal or unequal)"
  (cond ((equal list1 list2) :equal)
        ;; Thanks to Verdammelt for teaching me `search`:
        ((search list1 list2) :sublist)
        ((search list2 list1) :superlist)
        (t :unequal)))
