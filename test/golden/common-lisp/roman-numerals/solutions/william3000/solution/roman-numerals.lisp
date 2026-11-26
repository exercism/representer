(defpackage :roman-numerals
  (:use :cl)
  (:export :romanize))

(in-package :roman-numerals)

(defconstant letter-values
  '((#\I #\V . 1)
    (#\X #\L . 10)
    (#\C #\D . 100)
    (#\M nil . 1000)))

(defun romanize-digit (num into)
  (declare
   (type (integer 0) num)
   (type list into))
  (cond
    ((and (= num 9)
	  (not (null (cdr into)))
	  (not (null (cadr into))))
     (list (caadr into) (caar into)))
    ((and (= num 4)
	  (not (null (cadar into))))
     (list (cadar into) (caar into)))
    ((and (>= num 5)
	  (not (null (cadar into))))
     (append (romanize-digit (- num 5) into) (list (cadar into))))
    (t
     (make-list num :initial-element (caar into)))))

(defun partial-romanize (num into)
  (if (null into)
      (values '() num)
      (multiple-value-bind
	    (head num) (partial-romanize num (cdr into))
	(multiple-value-bind
	      (count remainder) (floor num (cddar into))
	  (values
	   (append (romanize-digit count into) head)
	   remainder)))))

(defun romanize (number)
  "Returns the Roman numeral representation for a given number."
  (multiple-value-bind
	(head rem) (partial-romanize number letter-values)
    (if (= rem 0)
	(coerce (reverse head) 'string))))

