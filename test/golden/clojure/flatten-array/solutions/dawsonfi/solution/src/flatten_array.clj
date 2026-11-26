(ns flatten-array)

(defn flatten [arr]
  (filter some? (clojure.core/flatten arr)))