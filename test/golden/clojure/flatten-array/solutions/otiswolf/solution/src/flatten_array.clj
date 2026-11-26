(ns flatten-array)

(defn flatten-helper [item]
  (cond 
    (vector? item) (mapcat flatten-helper item)
    (integer? item) [item]
    :else []))

(defn flatten [arr] ;; <- arglist goes here
  ;; your code goes here
  (mapcat flatten-helper arr)
)