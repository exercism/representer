(defpackage :larrys-winning-checker
  (:use :cl)
  (:export
   :make-empty-board
   :make-board-from-list
   :all-the-same-p
   :row
   :column))

(in-package :larrys-winning-checker)

(defconstant dimension 3)
(defun make-empty-board () (make-board-from-list (loop repeat dimension collect (loop repeat dimension collect nil))))

(defun make-board-from-list (list) (make-array (list dimension dimension) :initial-contents list))

(defun all-the-same-p (row-or-col) (every #'(lambda (elt) (eq elt (aref row-or-col 0))) row-or-col))

(defun row (board row-num) 
  (loop for j below dimension collect (aref board row-num j) into result finally (return (coerce result 'vector))))

(defun column (board col-num)
  (loop for i below dimension collect (aref board i col-num) into result finally (return (coerce result 'vector))))
