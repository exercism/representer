(defpackage :spiral-matrix
  (:use :cl)
  (:export :spiral-matrix))

(in-package :spiral-matrix)

(defun spiral-matrix (size)
  (when (plusp size)
    (do ((matrix (make-array (list size size)))
         (x 0 (+ x vx))
         (y 0 (+ y vy))
         (vx 1)
         (vy 0)
         (i 1 (1+ i)))
        ((> i (* size size)) matrix)

      (setf (aref matrix y x) i)

      ;; Turn if needed.
      (let ((nx (+ x vx))
            (ny (+ y vy)))
        (if (or (< nx 0)
                (>= nx size)
                (>= ny size)
                (plusp (aref matrix ny nx)))
            (let ((old-vx vx))
              (setf vx (- vy))
              (setf vy old-vx)))))))
