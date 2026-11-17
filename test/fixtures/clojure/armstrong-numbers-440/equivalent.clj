(ns armstrong-numbers) (defn armstrong? [num] (let [str-num (str num) len (count str-num)] (= num (apply + (map #(.pow (biginteger (str %)) len) str-num))) ) )
