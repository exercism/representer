(in-package #:cl-user)
(defpackage #:luhn
  (:use #:cl)
  (:export #:validp))

(in-package #:luhn)

(defun validp (input)
  ;Remove spaces from input
  (let ((input (remove #\SPACE input)))
    ;Check input
    (if (and (> (length input) 1) (every #'digit-char-p input))
        ;Check if divisible by 10
        (= (mod
            ;Sum all digits
            (apply '+ (loop for n in
                           ;Double every other number starting at tail
                           (loop for x across (reverse input)
                              for i from 1
                              if (oddp i) collect (digit-char-p x)
                              else collect (* (digit-char-p x) 2))
                         ;Subtract 9 from any digit greater than 9
                         if (> n 9) collect (- n 9)
                         else collect n))
            10)
           0))))

