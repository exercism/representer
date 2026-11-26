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
  "Make a blank 3x3 board. All cells of the board are NIL"
  (make-array '(3 3) :initial-element nil))

(defun make-board-from-list (list)
  "Make a 3x3 board from `LIST', which is a list of 3 list cointaing 3
elements."
  (make-array '(3 3) :initial-contents list))

(defun all-the-same-p (row-or-col)
  "Check there are 3 of the same symbol in `ROW-OR-COL', which is a
vector containing 3 elements."
  (and (eq (aref row-or-col 0)
               (aref row-or-col 1))
           (eq (aref row-or-col 1)
               (aref row-or-col 2))))

(defun row (board row-num)
  "Return a vector containing all the elements of the row number
`ROW-NUM' of `BOARD', which is a 3x3 array."
  (vector
   (aref board row-num 0)
   (aref board row-num 1)
   (aref board row-num 2)))

(defun column (board col-num)
    "Return a vector containing all the elements of the column number
`COL-NUM' of `BOARD', which is a 3x3 array."
  (vector
   (aref board 0 col-num)
   (aref board 1 col-num)
   (aref board 2 col-num)))
