(defpackage :collatz-conjecture
  (:use :cl)
  (:export :collatz))

(in-package :collatz-conjecture)

(defun collatz (n)
  (if (> n 0)
  (let ((i 0)) 
       (loop
          (when (= n 1) (return i))
          (setf n (if (= 0 (mod n 2)) (/ n 2) (+ 1 (* 3 n))))
          (setf i (+ i 1)))))
)
