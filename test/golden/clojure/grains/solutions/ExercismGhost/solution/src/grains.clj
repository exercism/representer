(ns grains)

(defn square [x]
  (.pow (biginteger 2) (dec x)))

(defn total []
  (dec (square 65)))
