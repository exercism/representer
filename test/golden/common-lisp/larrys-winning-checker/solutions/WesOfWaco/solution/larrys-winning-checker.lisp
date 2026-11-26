(defpackage :larrys-winning-checker
  (:use :cl)
  (:export
   :make-empty-board
   :make-board-from-list
   :all-the-same-p
   :row
   :column))

(in-package :larrys-winning-checker)

(defun make-empty-board ()
  "Make an empty board"
  (make-array '(3 3) :initial-element nil))

(defun make-board-from-list (list)
  "Make a board from a list of rows"
  (make-array '(3 3) :initial-contents list))

(defun all-the-same-p (row-or-col)
  "Produce true if all of the elements in a row or column are eq."
  (let ((ss (elt row-or-col 0)))
    (every #'(lambda (s)
	       (eq s ss))
	   row-or-col)))	       

(defun row (board row-num)
  "Given a Board, produce the Row indicated by row-num"
  (make-array 3
	      :initial-contents
	      (loop
		for c from 0 to 2
		collect (aref board row-num c))))

(defun column (board col-num)
  "Given a Board, produce the Colum idicated by col-num"
  (make-array 3
	      :initial-contents
	      (loop
		for r from 0 to 2
		collect (aref board r col-num))))
    ;; collect (aref (aref board r) col-num)))
