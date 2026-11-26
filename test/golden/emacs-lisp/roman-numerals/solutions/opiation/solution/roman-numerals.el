;;; roman-numerals.el --- roman-numerals Exercise (exercism)

;;; Commentary:

;;; Code:

;; 
(defun to-roman (number)
  "Convert the given NUMBER to a roman numeral representation.

Note, this function does not compact thousands beyond repeating the character
`M' as may be found in some roman texts using a horizontal line above the
character to indicate 1000 times its value."
  (interactive)
  
  ;; With little mathematical knowledge, this seemed like a simple enough
  ;; approach to break down the number into its positional digits. I'm sure
  ;; there's a stateless way of accomplishing this using a conditional loop and
  ;; reducing the remaining number iteratively.
  (let* ((ones (% number 10))
         (after-ones (/ (- number ones) 10))
         (tens (% after-ones 10))
         (after-tens (/ (- after-ones tens) 10))
         (hundreds (% after-tens 10))
         (after-hundreds (/ (- after-tens hundreds) 10))
         (thousands (% after-hundreds 10)))
    ;; There is certainly a way to do this by reducing over a sequence of 3
    ;; number sets but given the implicit upper bound of 3000 as a `number',
    ;; this seemed reasonably easy to understand.
    ;;
    ;; Otherwise, one could create sets of representations based a value
    ;; system that favors 5s. Every set of 5 (e.g.: 0 to 4, 5 to 9, 10 to 40, 50
    ;; to 90, 100 to 400, etc.) can be represented with a set of 3 characters:
    ;; the `base', the `increment' and the `next-base'.
    ;; For 0 to 4, the base, increment and next base are `nil', `?I' and `?V'
    ;; respectively, then the lower bound (e.g.: `0') can be represented as just
    ;; the `base'. The upper bound can be represented as the `increment' and the
    ;; `next-base'. The other 3 can be represented as the `base'` and
    ;; concatenated `increment's.
       (concat
        ;; Thousands in roman numerals
        (make-string thousands ?M)
        ;; Hundreds in roman numerals
        (cond ((= hundreds 9) "CM")
              ((= hundreds 8) "DCCC")
              ((= hundreds 7) "DCC")
              ((= hundreds 6) "DC")
              ((= hundreds 5) "D")
              ((= hundreds 4) "CD")
              (t (make-string hundreds ?C)))
        ;; Tens in roman numerals
        (cond ((= tens 9) "XC")
              ((= tens 8) "LXXX")
              ((= tens 7) "LXX")
              ((= tens 6) "LX")
              ((= tens 5) "L")
              ((= tens 4) "XL")
              (t (make-string tens ?X)))
        ;; Ones in roman numerals
        (cond ((= ones 9) "IX")
              ((= ones 8) "VIII")
              ((= ones 7) "VII")
              ((= ones 6) "VI")
              ((= ones 5) "V")
              ((= ones 4) "IV")
              (t (make-string ones ?I))))))

(provide 'roman-numerals)
;;; roman-numerals.el ends here
