(ns armstrong-numbers) (defn armstrong? [num] (let [num-seq (sequence (str num)) powed (map #(.pow (BigInteger. (str %) ) (count num-seq)) num-seq)] (= num (reduce + powed))) )
