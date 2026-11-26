(defpackage :nth-prime
  (:use :cl)
  (:export :find-prime))

(in-package :nth-prime)

(defun is-prime (n)
  (cond ((= 2 n) t)
	((= 3 n) t)
	((evenp n) nil)
	(t
	 (loop for i  from 3 to (isqrt n) by 2
	       never (zerop (mod n i))))))

(defun find-prime (number)
  (cond
    ((zerop number) nil)
    (t (do ((i 2) (count 1))
	   ((eql count number) i)
	 (setq i (1+ i))
	 (when (is-prime i) (setq count (1+ count)))))))
