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
  (make-array '(3 3) :initial-element nil))

(defun make-board-from-list (l)
  (make-array (list (length l)
		    (length (first l)))
	      :initial-contents l))

(defun all-the-same-p (row-or-col)
  (let ((a (aref row-or-col 0))
	(b (aref row-or-col 1))
	(c (aref row-or-col 2)))
    (and (equalp a b) (equalp b c))))

(defun row (board row-num)
  (let ((a (aref board row-num 0))
	(b (aref board row-num 1))
	(c (aref board row-num 2)))
    (make-array 3 :initial-contents (list a b c))))

(defun column (board col-num)
  (let ((a (aref board 0 col-num))
	(b (aref board 1 col-num))
	(c (aref board 2 col-num)))
    (make-array 3 :initial-contents (list a b c))))
