(defpackage :saddle-points
  (:use :cl)
  (:export :saddle-points))

(in-package :saddle-points)

(defun saddle-points (matrix)
  (setq saddle-points nil)
  (destructuring-bind (n m) (array-dimensions matrix)
    (loop for i from 0 below n do
      (loop for j from 0 below m
            when (saddle-point-p matrix i j)
            do (push (list (1+ i) (1+ j)) saddle-points))))
  saddle-points)

(defun saddle-point-p (matrix i j)
  "Returns true if the value at position I,J of the MATRIX is
   a saddle point for the MATRIX."
  (destructuring-bind (n m) (array-dimensions matrix)
    (and
      (loop for k from 0 below n
            always (< (aref matrix i j) (aref matrix k j)))
      (loop for l from 0 below m
            always (>= (aref matrix i j) (aref matrix i l))))))
