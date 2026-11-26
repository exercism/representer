(ns flatten-array)

(defn flatten [coll]
  (filter some? (clojure.core/flatten coll)))