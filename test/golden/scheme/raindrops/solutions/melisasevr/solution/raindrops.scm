(import (rnrs))
(define (convert number)
  (define (divides? dividend divisor)
    (= 0 (remainder dividend divisor)))
  (let ((pling (if (divides? number 3)
                   "Pling"
                   ""))
        (plang (if (divides? number 5)
                   "Plang"
                   ""))
        (plong (if (divides? number 7)
                   "Plong"
                   "")))
    (let ((result (string-append pling plang plong)))
      (if (equal? result "")
          (number->string number)
          result))))

