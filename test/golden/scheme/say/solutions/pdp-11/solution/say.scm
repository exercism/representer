(import (rnrs))
(use-modules (srfi srfi-11))

(define %digit-words
  #("zero" "one" "two" "three" "four"
    "five" "six" "seven" "eight" "nine"))

(define %teen-words
  #("ten" "eleven" "twelve" "thirteen" "fourteen"
    "fifteen" "sixteen" "seventeen" "eighteen" "nineteen"))

(define %ten-words
  #("zero" "ten" "twenty" "thirty" "forty"
    "fifty" "sixty" "seventy" "eighty" "ninety"))

(define (%say-3-digits number)
  (let* ((strs (if (< number 100) '()
                   `("hundred" ,(vector-ref %digit-words
                                            (quotient number 100)))))
         (number (modulo number 100))
         (strs (cond ((< number 10)
                      (if (zero? number) strs
                          `(,(vector-ref %digit-words number)
                            . ,strs)))
                     ((< number 20)
                      `(,(vector-ref %teen-words (- number 10))
                        . ,strs))
                     (else (let-values (((q r) (floor/ number 10)))
                             `(,(if (zero? r)
                                    (vector-ref %ten-words q)
                                    (string-join
                                     `(,(vector-ref %ten-words q)
                                       ,(vector-ref %digit-words r))
                                     "-"))
                               . ,strs))))))
    (string-join (reverse! strs))))

(define (say number)
  (when (< number 0)
    (error "input number should not be negative" number))
  (let loop ((number number) (strs '())
             (orders '(#f "thousand" "million" "billion")))
    (if (zero? number)
        (if (null? strs) "zero" (string-join strs))
        (let* ((tail (modulo number 1000))
               (str (%say-3-digits tail)))
          (loop (quotient number 1000)
                (if (string-null? str) strs
                    (let ((order (car orders)))
                      `(,str ,@(if order `(,order) '()) . ,strs)))
                (cdr orders))))))
