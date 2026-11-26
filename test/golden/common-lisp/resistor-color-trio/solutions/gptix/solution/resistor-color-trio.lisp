(defpackage :resistor-color-trio
  (:use :cl)
  (:export :label))

(in-package :resistor-color-trio)

(defparameter *color-code-alist*
  '(("black" . 0) ("brown" . 1) ("red" . 2) ("orange" . 3) ("yellow" . 4)
    ("green" . 5) ("blue" . 6) ("violet" . 7) ("grey" . 8) ("white" . 9)))

(defun color-to-number (color)
  (cdr (assoc color *color-code-alist* :test #'equal)))

(defun label (colors)
  (let ((first-three-colors (subseq colors 0 3)))
    (destructuring-bind
	(first-number second-number third-number)
	(mapcar #'color-to-number first-three-colors)
      (let* ((resistance (* (+ (* 10 first-number) second-number) (expt 10 third-number))))
	(multiple-value-bind 
	      (thousand-power remainder) 
	    (floor (count #\0 (format nil "~a" resistance)) 3)
	  (format nil
		  ;; builds format string for outer format
		  (format nil "~~a ~aohm~~:p"  (case thousand-power (3 "giga") (2 "mega") (1 "kilo") (t ""))
			  thousand-power) (floor resistance (expt 10 (* 3 thousand-power))))
	  ) ; multiple-value-bind
	) ; let*
      ) ; destructuring-bind
    ); let
  ); defun
