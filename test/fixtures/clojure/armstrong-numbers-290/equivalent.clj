(ns armstrong-numbers) (defn digits [n] (->> n str (map (comp read-string str)))) (defn armstrong? [num] (->> (digits num) (map #(reduce * (repeat (count (str num)) %))) (reduce +) (= num)))
