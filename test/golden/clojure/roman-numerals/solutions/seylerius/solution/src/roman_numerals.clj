(ns roman-numerals)

(defn roman-numeral [n]
  (condp <= n
    1000 (lazy-seq (cons "M" (roman-numeral (- n 1000))))
    900  (lazy-seq (cons "CM" (roman-numeral (- n 900))))
    500  (lazy-seq (cons "D" (roman-numeral (- n 500))))
    400  (lazy-seq (cons "CD" (roman-numeral (- n 400))))
    100  (lazy-seq (cons "C" (roman-numeral (- n 100))))
    90   (lazy-seq (cons "XC" (roman-numeral (- n 90))))
    50   (lazy-seq (cons "L" (roman-numeral (- n 50))))
    40   (lazy-seq (cons "XL" (roman-numeral (- n 40))))
    10   (lazy-seq (cons "X" (roman-numeral (- n 10))))
    9    (lazy-seq (cons "IX" (roman-numeral (- n 9))))
    5    (lazy-seq (cons "V" (roman-numeral (- n 5))))
    4    (lazy-seq (cons "IV" (roman-numeral (- n 4))))
    1    (lazy-seq (cons "I" (roman-numeral (- n 1))))
    '()))

(defn numerals [n]
  (apply str (roman-numeral n)))
