(defpackage :nth-prime
  (:use :cl)
  (:export :find-prime))

(in-package :nth-prime)

(defun find-prime (number)
  (when (plusp number)
    (loop :for i :from 2
          :when (primep i)
            :sum 1 :into nth
          :when (= nth number)
            :do (return i))))

(defun primep (number)
  (when (> number 1)
  (loop :for j :from 2 to (sqrt number)
        :never (zerop (mod number j)))))