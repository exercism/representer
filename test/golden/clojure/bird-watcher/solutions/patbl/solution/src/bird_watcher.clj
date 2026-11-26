(ns bird-watcher)

(def last-week 
  [0 2 5 3 7 8 4])

(def today peek)

(defn inc-bird [birds]
  (conj (pop birds) (inc (today birds))))

(defn day-without-birds? [birds]
  (some? (some zero? birds)))

(defn n-days-count [birds n]
  (reduce + (take n birds)))

(defn busy-days [birds]
  (count (filter #(>= % 5) birds)))

(defn odd-week? [birds]
  (= birds (take (count birds) (cycle [1 0]))))
