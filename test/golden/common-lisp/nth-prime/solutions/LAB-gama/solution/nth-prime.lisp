(defpackage :nth-prime
  (:use :cl)
  (:export :find-prime))

(in-package :nth-prime)

(defun is-multiple (number prime)
  (and (> number prime) (zerop (rem number prime))))

(defun create-wheel (start-point &rest prime-basis)
  "Create a factorization wheel from the points in PRIME-BASIS. The START-POINT
(the next prime number) is usually set by either the sieve of erasthotenes or smaller factorization
wheels; it is specified as an external parameter in this implementation."
  (let ((number-list (loop :for i :from 2 :upto (+ (reduce #'* prime-basis) start-point)
			   :collect i))
	(max-prime (apply #'max prime-basis)))
    (loop :for prime :in prime-basis :do
      (setf number-list (delete-if (lambda (num) (is-multiple num prime))
				   number-list)))
    (setf number-list (coerce (remove-if (lambda (x) (<= x max-prime)) number-list)
			      'simple-vector))

    (let ((wheel-differences (loop :for i :from 1 :below (length number-list)
				   :collect (- (aref number-list i) (aref number-list (1- i))))))
      (make-array (length wheel-differences) :initial-contents wheel-differences))))

(defparameter *wheel-2357* (create-wheel 11 2 3 5 7)
    "Use a 2-3-5-7 Pritchard (1980) factorization wheel to compute number candidates in
FIND-PRIME. This is done to greatly speed up the search of prime numbers, as more than
2/3 of composite number lookups are eliminated a priori by the factorization wheel.")

(defun find-prime (number)
  (labels ((is-prime (number prime-list)
	     (notany (lambda (prime) (is-multiple number prime)) prime-list))

	   (spin (count-of-primes current-prime counter prime-list)
	     (if (< count-of-primes number)
		 (if (is-prime current-prime prime-list)
		     (spin (1+ count-of-primes)
			   (+ current-prime (aref *wheel-2357*
						  (mod counter (length *wheel-2357*))))
			   (1+ counter)
			   (cons current-prime prime-list))
		     (spin count-of-primes
			   (+ current-prime (aref *wheel-2357*
						  (mod counter (length *wheel-2357*))))
			   (1+ counter)
			   prime-list))
		 prime-list)))
    
    (case number
      (1 2)
      (2 3)
      (3 5)
      (4 7)
      (t (when (> number 5) (first (spin 4 11 0 '(7 5 3 2))))))))
