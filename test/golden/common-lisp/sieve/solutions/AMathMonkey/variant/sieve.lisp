(defpackage :sieve
  (:use :cl)
  (:export :primes-to)
  (:documentation "Generates a list of primes up to a given limit."))

(in-package :sieve)

;; My first iteration is cleaner; this is just for practice
;; with DO, because I've never used it before
(defun positions (val vec)
  "Returns all the indices of a vector where the value EQLs val"
  (do ((prev (position val vec) (position val vec :start (1+ prev)))
       (result (list)))
      ((not prev) (nreverse result))
    (push prev result)))

(defun primes-to (n)
  "List primes up to `n' using sieve of Eratosthenes."
  (loop with primes = (make-array (1+ n) :initial-element t)
   for i from 2 to n
   if (elt primes i)
   do (loop for j from (/ 2 i) to n by i do (setf (elt primes j) nil))
   finally (return (cddr (positions t primes)))))
