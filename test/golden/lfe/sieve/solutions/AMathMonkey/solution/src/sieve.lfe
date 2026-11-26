(defmodule sieve
  (export (primes 1)))

(defun primes (upper-bound)
  (find-unmarked (get-marked upper-bound) upper-bound))

(defun get-marked (upper-bound)
  (fletrec ((loop (n acc)
              (if (> n upper-bound) acc
                (if (sets:is_element n acc)
                  (loop (+ 1 n) acc)
                  (loop (+ 1 n) (mark-multiples n acc upper-bound))))))
    (loop 2 (sets:new))))

(defun mark-multiples (n acc upper-bound)
  (fletrec ((loop (i acc)
              (if (> i upper-bound) acc
                (loop (+ i n) (sets:add_element i acc)))))
    (loop (* n 2) acc)))

(defun find-unmarked (marked upper-bound)
  (fletrec ((loop (n acc)
              (if (> n upper-bound) (lists:reverse acc)
                (loop (+ 1 n) (if (sets:is_element n marked) acc (cons n acc))))))
    (loop 2 '())))
 