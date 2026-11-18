(ns armstrong-numbers) (defn armstrong? [num] (let [digits (map #(Character/getNumericValue %) (str num)) exp (count digits)] (= num (reduce + (map #(.pow (biginteger %) exp) digits))) ) )
