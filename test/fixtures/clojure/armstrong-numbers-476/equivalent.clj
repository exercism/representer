(ns armstrong-numbers) (defn armstrong? [num] (->> (str num) (seq) (map #(Long/parseLong (str %))) (map #(reduce * (repeat (count (str num)) %))) (reduce +) (= num)))
