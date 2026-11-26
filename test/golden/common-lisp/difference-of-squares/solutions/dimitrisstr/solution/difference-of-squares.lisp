(defpackage :difference-of-squares
  (:use :cl)
  (:export :sum-of-squares
           :square-of-sum
           :difference))

(in-package :difference-of-squares)

(defun square-of-sum (n)
  (labels ((sum (number)
                 (if (= number 1)
                     1
                     (+ number (sum (- number 1))))))
          (expt (sum n) 2)))
  
  

(defun sum-of-squares (n)
  (if (= n 1)
      1 
      (+ (expt n 2) (sum-of-squares (- n 1)))))

(defun difference (n)
  (- (square-of-sum n) (sum-of-squares n)))
