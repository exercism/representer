(defpackage :sublist
  (:use :cl)
  (:export :sublist))

(in-package :sublist)

(defun cons-first (list n)
	"Returns the n first conses of a list"
	(reverse (last (reverse list) n))
	)

(defun slice-length (list start-index out-length)
	"Returns a slice of a list from the start-index (starting at 0) and of length
out-length"
	(cons-first (nthcdr start-index list) out-length)
	)

(defun list-a-has-b (lista listb)
	"Is listb in lista?"
	(let ((n-sublist-candidates (- (length lista)
																 (1- (length listb))))
				(listb-in-lista nil))
		(dotimes (i n-sublist-candidates)
			(cond
				((every #'identity  (mapcar #'=
																		(slice-length lista i (length listb))
																		listb))
				 (setf listb-in-lista t))))
		listb-in-lista))

(defun sublist (list1 list2)
  "what is list1 of list2 (sublist, superlist, equal or unequal)"
	(cond
		((equal list1 list2) :equal)
		((list-a-has-b list1 list2) :superlist)
		((list-a-has-b list2 list1) :sublist)
		(t :unequal)
		))
