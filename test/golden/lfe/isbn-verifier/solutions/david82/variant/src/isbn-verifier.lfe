(defmodule isbn-verifier
  (export (valid? 1)))

;;; Parse a character into its integer value.
;;; 'X' is only allowed when weight is 1 (the check digit position).
(defun parse-char
  ((char weight) (when (andalso (>= char 48) (=< char 57)))
   (tuple 'ok (- char 48)))
  ((89 1)
   (tuple 'ok 10))
  ((_ _)
   'error))

;;; Recursively calculate the weighted checksum.
(defun verify
  (('() 0 acc)
   (== (rem acc 11) 0))
  (((cons char rest) weight acc) (when (> weight 0))
   (case (parse-char char weight)
     ((tuple 'ok val)
      (verify rest (- weight 1) (+ acc (* val weight))))
     ('error
      'false)))
  ((_ _ _)
   'false))

;;; Main entry point
(defun valid? (isbn)
  (let ((filtered (lists:filter (lambda (c) (/= c 45)) isbn)))
    (if (== (length filtered) 10)
        (verify filtered 10 0)
        'false)))