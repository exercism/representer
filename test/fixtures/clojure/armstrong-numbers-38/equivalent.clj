(ns armstrong-numbers) (defn armstrong? [num] (let [s (str num) len (count s)] (->> s (map #(Integer/parseInt (str %))) (map #(apply * (repeat len %))) (apply +) (= num))))
