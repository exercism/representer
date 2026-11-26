(ns strain)

(defn retain
  ([f coll]
    (retain f coll []))
  ([f [head & tail] acc]
    (if (nil? head)
        acc
        (if (f head)
            (retain f tail (conj acc head))
            (retain f tail acc)))))

(defn discard [f coll]
  (retain (complement f) coll))
