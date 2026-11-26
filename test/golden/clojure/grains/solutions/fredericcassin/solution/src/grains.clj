(ns grains)

(defn square [s]
  (.shiftLeft (biginteger 1) (dec s)))

(defn total []
  (dec (square 65)))
