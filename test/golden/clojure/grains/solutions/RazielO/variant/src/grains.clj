(ns grains)

(defn square
  "Returns the number of grains on the n-th chessboard square."
  [n]
  (.shiftLeft (biginteger "1") (dec n)))

(defn total
  "Returns the total number of grains on the chessboard."
  []
  (reduce - (map square (range 1 65))))
