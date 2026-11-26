(ns sum-of-multiples)

(defn sum-of-multiples [coll n]
  (->> coll
       (mapcat #(range % n %))
       distinct
       (apply +)))
