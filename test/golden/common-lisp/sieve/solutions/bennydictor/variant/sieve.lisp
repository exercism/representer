(defpackage #:sieve
  (:use #:cl)
  (:export #:primes-to)
  (:documentation "Generates a list of primes up to a given limit."))

(in-package #:sieve)

(defun is-prime (n)
  (loop for i from 2 while (<= (/ i i) n)
        do (if (= (mod n i) 0)
             (return-from is-prime NIL)))
  T)

(defun primes-to (n)
  (let ((ret nil))
    (loop for i from n downto 2
          do (if (is-prime i)
               (push i ret)))
    ret))