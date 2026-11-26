(ns flatten-array)

(defn flatten
  "it's like clojure.core/flatten except removes nil values"
  [coll]
  (remove nil? (clojure.core/flatten coll)))