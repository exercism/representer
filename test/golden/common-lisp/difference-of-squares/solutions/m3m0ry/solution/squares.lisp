(defpackage #:squares
  (:use #:cl)
  (:export #:sum-of-squares
           #:square-of-sums
           #:difference))

(in-package #:squares)

(defun square-of-sums (n)
  (expt (loop for i to n summing i) 2))

(defun sum-of-squares (n)
  (apply '+ (loop for i to n collect (expt i 2))))

(defun difference (n)
  (- (square-of-sums n) (sum-of-squares n)))
