(ns bird-watcher)

(def last-week [0 2 5 3 7 8 4])

(defn today [birds] (last birds))

(defn inc-bird [birds] (concat (pop birds) [(inc (last birds))]))


(defn day-without-birds? [[a & birds]] (if a (if (= a 0) true (day-without-birds? birds)) false))
(defn n-days-count [[a & birds] n] (if (and a (> n 0)) (+ a (n-days-count birds (dec n))) 0))

(defn busy-days [[a & birds]] (if a (+ (if (>= a 5) 1 0) (busy-days birds)) 0))
;; => #'bird-watcher/busy-days

(defn odd-week? [[a & birds]] (if a (if (or (not= a 0) (= a 1)) (odd-week? birds) false) true))


(odd-week? [1 0 1 0 1 0 2])

(busy-days [1 8 5 7 4])

(n-days-count [5 4 3 2] 3)

(inc-bird [1 2 3])


(day-without-birds? [1 2 3 0])


(conj [:a :b :c] :d)

(type [1 2 3])
(type '(1 2 3))

(if 0 :true :false)
