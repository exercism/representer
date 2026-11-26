(defpackage :triangle
  (:use :cl)
  (:export :triangle-type-p))

(in-package :triangle)

(defun triangle-p (a b c)
  (and (and (> a 0)
			(> b 0)
			(> c 0))
	   (or (>= (+ a b) c)
			(>= (+ b c) a)
			(>= (+ a c) b))))

(defun triangle-type-p (type a b c)
  "Deterimines if a triangle (given by side lengths A, B, C) is of the given TYPE"
  ;; equilateral = 3 same
  ;; isosceles >= 2 same
  ;; scalene all different
  (let ((ans))
	(if (triangle-p a b c)
		(cond
		  ((eql type :equilateral)
		   (when (= a b c)
			 (setf ans t)))
		  ((eql type :isosceles)
		   (when (or (= a b) (= a c) (= b c))
			 (setf ans t)))
		  ((eql type :scalene)
		   (when (and (/= a b) (/= a c) (/= b c))
			 (setf ans t)))))
	ans))
