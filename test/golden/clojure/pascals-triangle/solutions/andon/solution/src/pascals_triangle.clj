(ns pascals-triangle)

(defn fact [n]()
  (apply *' (range 1 (inc n))))

(defn binom [n r]
  (/ (fact n) (*' (fact r) (fact (-' n r)))))

(defn row [n]
  (map (partial binom (dec n)) (range 0 n)))

(defn triangle-seq
  ([] (triangle-seq 1))
  ([n] (lazy-seq (cons (row n) (triangle-seq (inc n))))))

(def triangle (triangle-seq))
