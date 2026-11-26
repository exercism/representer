(ns hexadecimal)

(ns hexadecimal)

(defn expt [x power]
  (->> x
       (repeat power)
       (reduce *)))

(defn hex->digit [position value]
  (* value (expt 16 position)))

(defn hex-value [hex-char]
  (case hex-char
    \0      0
    \1      1
    \2      2
    \3      3
    \4      4
    \5      5
    \6      6
    \7      7
    \8      8
    \9      9
    (\a \A) 10
    (\b \B) 11
    (\c \C) 12
    (\d \D) 13
    (\e \E) 14
    (\f \F) 15))

(defn hex-to-int [hex-string]
  (if (re-matches #"^[\p{XDigit}]+$" hex-string)
    (->> hex-string
         reverse
         (map hex-value)
         (map hex->digit (range))
         (reduce +))
    0))
