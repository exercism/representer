(defpackage #:sublist
  (:use #:common-lisp)
  (:export #:sublist))

(in-package #:sublist)

(defun sublist (list1 list2)
  "what is list1 of list2 (sublist, superlist, equal or unequal)"
  (cond 
    ((equal list1 list2) :equal)
    ((search list1 list2) :sublist)
    ((search list2 list1) :superlist) 
    (t :unequal)))

    ; Alternative implementation for faster sublist:
    ; ((and (= (length list1) (length list2)) (equal list1 list2)) :equal)
    ; ((and (< (length list1) (length list2)) (search list1 list2)) :sublist)
    ; ((and (> (length list1) (length list2)) (search list2 list1)) :superlist)