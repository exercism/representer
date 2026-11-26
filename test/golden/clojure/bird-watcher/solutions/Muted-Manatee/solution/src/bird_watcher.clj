(ns bird-watcher)

(def last-week 
  [0 2 5 3 7 8 4])

(subvec last-week 0 4)

(defn last-index-of [v]
  (- (count v) 1))

(defn today [birds]
  (birds (last-index-of birds)))

(defn inc-bird [birds]
  (update birds (last-index-of birds) inc))

(defn day-without-birds? [birds]
  (pos? (.indexOf birds 0)))

(defn n-days-count [birds n]
  (reduce + (subvec birds 0 n)))

(defn busy-days [birds]
  (count (filter #(>= % 5) birds)))

(defn odd-week? [birds]
  (let [one-zeros (map #(if (zero? (rem % 2)) 1 0) (range (count birds)))
        zero-ones (map #(rem % 2) (range (count birds)))]
    (or (= one-zeros birds) (= zero-ones birds))))
