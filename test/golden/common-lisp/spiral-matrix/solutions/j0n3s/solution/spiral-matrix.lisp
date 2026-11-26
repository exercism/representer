(defpackage :spiral-matrix
  (:use :cl)
  (:export :spiral-matrix :fill-table))

(in-package :spiral-matrix)

(defun fill-table (board pos dir idx size)
  (if (> idx (* size size))
      board
      (progn
       (setf (aref board (realpart pos) (imagpart pos)) idx)
       (let ((new-pos (+ pos dir))
             (new-dir (* dir #C(0 -1))))
         (if (and
              (>= (realpart new-pos) 0)
              (>= (imagpart new-pos) 0)
              (< (realpart new-pos) size)
              (< (imagpart new-pos) size)
              (not (aref board (realpart new-pos) (imagpart new-pos))))
             (fill-table board new-pos dir (1+ idx) size)
             (fill-table board (+ pos new-dir) new-dir (1+ idx) size))))))

(defun spiral-matrix (size)
  (if (> size 0)
      (let ((board (make-array (list size size) :initial-element nil))
            (pos #C(0 0))
            (dir #C(0 1)))
        (fill-table board pos dir 1 size))))