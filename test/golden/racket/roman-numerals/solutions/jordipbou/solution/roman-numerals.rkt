#lang racket

(provide to-roman)

(define (to-roman n)
  (let ([units '("" "I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX")]
		[tens '("" "X" "XX" "XXX" "XL" "L" "LX" "LXX" "LXXX" "XC")]
		[hundreds '("" "C" "CC" "CCC" "CD" "D" "DC" "DCC" "DCCC" "CM")]
		[thousands '("" "M" "MM" "MMM")])
	(string-append
	  (list-ref thousands (quotient n 1000))
	  (list-ref hundreds (modulo (quotient n 100) 10))
	  (list-ref tens (modulo (quotient n 10) 10))
	  (list-ref units (remainder n 10)))))
