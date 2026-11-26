(ns flatten-array)

(defn flatten [ar]
  (remove nil? (clojure.core/flatten ar)))