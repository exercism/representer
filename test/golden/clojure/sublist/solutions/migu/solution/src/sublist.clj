(ns sublist)

(defn- sublist? [as bs]
  (->> bs
       (partition (count as) 1)
       (some #{as})))

(defn classify [a b]
  (cond
    (= a b) :equal
    (sublist? a b) :sublist
    (sublist? b a) :superlist
    :else :unequal))
