(defpackage :pascals-triangle
  (:use :cl)
  (:export :rows))
(in-package :pascals-triangle)

(defun factorial (n)
  (if (not (plusp n)) 1
      (* n (factorial (1- n)))))

(defun range (n)
  (loop for i from 0 below n collect i))

(defun partial-apply (fn &rest args)
  (lambda (&rest more-args)
    (apply fn (append args more-args))))

(defun apply-fn (fn) (lambda (&rest args) (apply #'(lambda (nk) (apply fn nk)) args)))

(defun n-choose-k (n k)
  (/ (factorial n)
     (* (factorial k)
        (factorial (- n k)))))

(defun rows (n)
  (let ((entries
          (mapcar
           #'(lambda (r) (mapcar (partial-apply #'list r) (range (1+ r))))
           (range n))))
    (mapcar #'(lambda (row) (mapcar (apply-fn #'n-choose-k) row))
            entries)))
