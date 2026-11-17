(ns armstrong-numbers) (defn armstrong? [num] (let [arr (clojure.string/split (str num) #"")] (= num (reduce + (map #(.pow (biginteger %) (count arr)) arr)))))
