(ns hexadecimal)

(defn char-to-int [character]
  (case character
    \0 0
    \1 1
    \2 2
    \3 3
    \4 4
    \5 5
    \6 6
    \7 7
    \8 8
    \9 9
    \a 10
    \b 11
    \c 12
    \d 13
    \e 14
    \f 15
    (throw (IllegalArgumentException. "Other character found"))))

(defn hex-to-int [n]
  (try (apply + (map-indexed (fn [index value] (long (* (char-to-int value) (java.lang.Math/pow 16 index)))) (reverse (vec n)))) 
    (catch IllegalArgumentException e 0))
)
