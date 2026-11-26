(ns grains)

(defn square [n]
  (if (= n 1)
    1
    (* 2N (square (dec n)))))

(defn total []
  (- (square 65N) 1))