(ns bird-watcher)

(def last-week 
  [0 2 5 3 7 8 4])

(defn today [birds]
  (last birds))

(defn inc-bird [birds]
  (assoc birds 6 (inc (today birds))))

(defn day-without-birds? [birds]
  (->> birds
    (filter #(= 0 %))
    count
    (< 0)))

(defn n-days-count [birds n]
  (->> birds
    (take n)
    (reduce +)))

(defn busy-days [birds]
  (->> birds
    (filter #(>= % 5))
    count))

(defn odd-week? [birds]
  (if (or (= birds [1 0 1 0 1 0 1]) (= birds [0 1 0 1 0 1 0]))
    true
    false)
  )
