(defpackage :isbn-verifier
  (:use :cl)
  (:export :validp))

(in-package :isbn-verifier)

(defun str-to-list (str)
  (loop for c across str
        collect c))

(defun clean-isbn (isbn)
  (let ((cl-isbn (reverse (remove #\- isbn))))
    (str-to-list cl-isbn)))

(defun compute-check (check-val)
  (cond
    ((null check-val) nil)
    ((char= #\X check-val) 10)
    ((not (null (digit-char-p check-val))) (digit-char-p check-val))
    (t nil)))

(defun calc-isbn (isbn-list-ints check-int)
  (let ((interim-sum (loop for n in isbn-list-ints
                            and i from 2 to (1+ (length isbn-list-ints))
                            summing (* i n))))
    (zerop (mod (+ interim-sum check-int) 11))))

(defun validp (isbn)
  (let* ((check-val (first (clean-isbn isbn)))
         (check-int (compute-check check-val))
         (isbn-list-ints (mapcar #'digit-char-p (rest (clean-isbn isbn)))))
    (cond
      ((not (= 9 (length isbn-list-ints))) nil)
      ((null check-int) nil)
      ((some #'null isbn-list-ints) nil)
      (t (calc-isbn isbn-list-ints check-int)))))
