(ns bird-watcher)

(def last-week 
  [0 2 5 3 7 8 4]
  )

(defn today [birds]
  (peek birds)
  )

(defn inc-bird [birds]
  (assoc birds 6 (inc (get birds 6)))
  )

(defn day-without-birds? [birds]
  (boolean (some #(= 0 %) birds))
  )

(defn n-days-count [birds n]
  (reduce + (subvec birds 0 n))
  )

(defn busy-days [birds]
  (reduce #(if (> %2 4) (inc %1) %1) 0 birds)
  )

(defn every-is-n? [numbers n]
  (every? #(= %1 n) numbers))

(defn odd-week? [birds]
  (and
   (every-is-n? (take-nth 2 birds) 1)
   (every-is-n? (take-nth 2 (rest birds)) 0)))
  
