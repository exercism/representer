#lang racket

(provide twelve-days)

(define elems #hash(
  (1 . ("first" . "a Partridge in a Pear Tree"))
  (2 . ("second" . "two Turtle Doves"))
  (3 . ("third" . "three French Hens"))
  (4 . ("fourth" . "four Calling Birds"))
  (5 . ("fifth" . "five Gold Rings"))
  (6 . ("sixth" . "six Geese-a-Laying"))
  (7 . ("seventh" . "seven Swans-a-Swimming"))
  (8 . ("eighth" . "eight Maids-a-Milking"))
  (9 . ("ninth" . "nine Ladies Dancing"))
  (10 . ("tenth" . "ten Lords-a-Leaping"))
  (11 . ("eleventh" . "eleven Pipers Piping"))
  (12 . ("twelfth" . "twelve Drummers Drumming"))))

(define (gifts up-to)
  (let ([gifts-list (for/list ([gift (in-range up-to 0 -1)])
                      (cdr (hash-ref elems gift)))])
    (string-join gifts-list ", " #:before-last ", and ")))

(define (twelve-days (from 1) (to 12))
  (string-join
    (for/list ([line (in-range from (add1 to))])
      (format "On the ~a day of Christmas my true love gave to me: ~a."
              (car (hash-ref elems line))
              (gifts line)))
    "\n\n"))
