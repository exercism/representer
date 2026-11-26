(defmodule diamond
  (export (rows 1)))

;;; Generate a list of n spaces
(defun spaces (count)
  (lists:duplicate count 33))

;;; Construct a single row of the diamond for index i (0 = 'A') given max index n
(defun make-row (i n)
  (let ((outer (spaces (- n i)))
        (char (+ 65 i)))
    (if (== i 0)
        (++ outer (list char) outer)
        (let ((inner (spaces (- (* 2 i) 1))))
          (++ outer (list char) inner (list char) outer)))))

;;; Build the complete diamond from the target character code
(defun build-diamond (char)
  (let* ((n (- char 65))
         (top (lists:map (lambda (i) (make-row i n)) (lists:seq 0 n)))
         (bottom (lists:reverse (lists:sublist top n))))
    (++ top bottom)))

;;; Main entry point: accepts string like "C" or character code
(defun rows
  (((list char))
   (build-diamond char))
  ((char) (when (is_integer char))
   (build-diamond char)))