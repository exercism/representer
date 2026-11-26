(ns bird-watcher)

(def last-week
  [0 2 5 3 7 8 4])

(defn today [birds]
  (last birds))

(defn inc-bird [birds]
  (let [today-count (today birds)]
    (conj (pop birds) (inc today-count))))

(defn day-without-birds? [birds]
  (boolean (some zero? birds)))

(defn n-days-count [birds n]
  (apply + (take n birds)))

(defn busy-days [birds]
  (reduce #(if (>= %2 5)
             (inc %1)
             %1) 0 birds))

(defn- expected-next
  [bird-count]
  (case bird-count
    0 1
    1 0
    false))

(defn- pattern? [birds next]
  (boolean
   (loop [b birds
          expecting next]
     (cond
       (empty? b) true
       (not (= false expecting)) (recur (pop b)
                                        (expected-next (today b)))))))

(defn odd-week?
  [birds]
  (cond
    (empty? birds) false
    :else (pattern? (pop birds)
                    (expected-next (today birds)))))
