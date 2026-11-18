(ns armstrong-numbers) (defn armstrong? [num] (def p (count (str num))) (= (biginteger (reduce +' (map #(.pow (biginteger (str %)) p) (str num)))) num) )
