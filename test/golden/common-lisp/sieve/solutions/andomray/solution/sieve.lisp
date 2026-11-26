(defpackage :sieve
  (:use :cl)
  (:export :primes-to)
  (:documentation "Generates a list of primes up to a given limit."))

(in-package :sieve)

;; NOTE: Adjust the number in the call to 'prime-list' in the function below if
;; you need to generate primes higher than a certain number.
(defun primes-to (n)
  "List primes up to `n' using sieve of Eratosthenes."
  (cond
    ((< n 2) nil)
    ((= n 2) '(2))
    (t (reverse (reduce (lambda (acc p) (if (<= p n) (cons p acc) acc)) (prime-list 1000) :initial-value '())))))

(setf *limit* 50000)    ; limit for maximum prime in list

;; Check this out at: https://system-call.blogspot.com/2013/11/the-sieve-of-atkin-in-common-lisp-update.html
;;; generate a list of nil's of lenght lim
(defun nullness (lim)
  (let ((lst '()))
    (do ((x 1 (+ x 1)))
        ((> x lim) lst)
      (setf lst (cons nil lst)))))

(defun sieve (lim)
  (setf is_prime (nullness lim))
  (do ((x 1 (+ x 1)))
      ((> x (+ (round (sqrt lim)) 1)) is_prime)
    (do ((y 1 (+ y 1)))
        ((> y (+ (round (sqrt lim)) 1)) is_prime)

      (setf n (+ (* 4 x x) (* y y)))
      (if (and (<= n lim) (or (eql (mod n 12) 1) (eql (mod n 12) 5)))
        (setf (nth n is_prime) (not (nth n is_prime))))

      (setf n (+ (* 3 x x) (* y y)))
      (if (and (<= n lim) (eql (mod n 12) 7))
        (setf (nth n is_prime) (not (nth n is_prime))))

      (setf n (- (* 3 x x) (* y y)))
      (if (and (> x y) (<= n lim) (eql (mod n 12) 11))
        (setf (nth n is_prime) (not (nth n is_prime)))))))

;;; set the square multiples of primes to false
(defun square-sieve (lst lim)
  (do ((n 0 (+ n 1)))
      ((> n (+ (round (sqrt lim))) 1) lst)
    (if (eql (nth n lst) 't)
      (do ((k (* n n) (+ k (* n n))))
          ((> k (- lim 1)) lst)
        (setf (nth k lst) nil)))))

;;; print the primes
(defun prime-print (primes)
  (let ((lst '())
        (max-length (list-length primes)))
    (do ((n 1 (+ n 1)))
        ((> n max-length) (cons 2 (cons 3 (reverse lst))))
      (if (eql (nth n primes) 't)
        (setf lst (cons n lst))))))

;;; produce the list of primes (better formatting)
(defun prime-list (lim)
  (prime-print (square-sieve (sieve lim) lim)))
