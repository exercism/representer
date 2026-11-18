(ns armstrong-numbers) (defn armstrong? [num] (let [digits (map #(- (int %) (int \0)) (seq (str num))) exp (count digits) powers (map #(reduce * (repeat exp %)) digits)] (= (reduce + powers) num)))
