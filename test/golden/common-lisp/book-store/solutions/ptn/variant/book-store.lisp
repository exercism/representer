(defpackage :book-store
  (:use :cl)
  (:export :calculate-price))

(in-package :book-store)

(defparameter *base-price* 8)

(defun optimize-groups (naive-groups)
  "Replace groups of 5 and 3 with two groups of 4, as that's always cheaper."
  (let ((min (min (elt naive-groups 2) (elt naive-groups 4))))
    (when (plusp min)
      (decf (elt naive-groups 2) min)
      (decf (elt naive-groups 4) min)
      (incf (elt naive-groups 3) (/ 2 min)))
    naive-groups))

(defun make-groups (basket)
  (do ((result (list 0 0 0 0 0))
       (my-basket (copy-list basket))
       (i 5 (1- i)))
      ((= i 0) (optimize-groups result))
    (multiple-value-bind
          (group-length kinds-remaining) (loop for b in my-basket
                                               when (plusp b)
                                                 minimize b into min
                                                 and count b into count
                                               finally (return (values min count)))
      (when (= kinds-remaining i)
        (setf (elt result (1- i)) group-length)
        (loop for i from 0 below 5
              do (decf (elt my-basket i) group-length))))))

(defun make-basket (raw)
  "Return a list of five numbers, each represents how many books of that kind are in the basket."
  (let ((result (list 0 0 0 0 0)))
    (loop for r in raw
          do (incf (elt result (1- r)))
          finally (return result))))

(defun calculate-price (proto-basket)
  (let ((groups (make-groups (make-basket proto-basket))))
    (loop for g in groups
          for i from 1 to 5
          sum (* i g *base-price* (case i
                                    (1 100)
                                    (2 95)
                                    (3 90)
                                    (4 80)
                                    (5 75))))))
