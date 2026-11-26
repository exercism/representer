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


(defun make-board-from-list (list)
  (make-array '(3 3) :initial-contents list))


(defun all-the-same-p (row-or-col)
  (and (eql (aref row-or-col 0)(aref row-or-col 1))
       (eql (aref row-or-col 0)(aref row-or-col 2))))



(defun row (board row-num)
  (case row-num
    (0 (vector (aref board 0 0)(aref board 0 1)(aref board 0 2)))
    (1 (vector (aref board 1 0)(aref board 1 1)(aref board 1 2)))
    (2 (vector (aref board 2 0)(aref board 2 1)(aref board 2 2)))))



(defun column (board col-num)
  (case col-num
    (0 (vector (aref board 0 0)(aref board 1 0)(aref board 2 0)))
    (1 (vector (aref board 0 1)(aref board 1 1)(aref board 2 1)))
    (2 (vector (aref board 0 2)(aref board 1 2)(aref board 2 2)))))






