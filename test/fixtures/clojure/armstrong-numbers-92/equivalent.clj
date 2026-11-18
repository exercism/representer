(ns armstrong-numbers) (defn armstrong? [num] (let [digits (str num) num-digits (count digits)] (= (->> digits (map #(apply * (repeat num-digits (- (int %) 48)))) (reduce +)) num)))
