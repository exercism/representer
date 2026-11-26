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

(defun all-equalp (args &key (test #'eq))
  (let ((l (length args)))
    (cond ((equal 0 l) (error "need at least one argument"))
          ((equal 1 l) t)
          (t (and (funcall test
                           (first args)
                           (second args))
                  (all-equalp (rest args) :test test))))))

(defun all-the-same-p (row-or-col)
  (all-equalp (coerce row-or-col 'list) :test #'equal))

(defun row (board row-num)
  (coerce (loop for i below (array-dimension board 0)
                collect (aref board row-num i))
          'vector))

(defun column (board col-num)
  (coerce (loop for i below (array-dimension board 1)
                collect (aref board i col-num))
          'vector))
