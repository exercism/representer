(ns armstrong-numbers) (defn armstrong? [num] (let [str-num (str num) length (count str-num)] (== num (reduce + (map #(.pow (bigdec (Integer/parseInt (str %))) length) str-num)))))
