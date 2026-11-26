(ns difference-of-squares)

(defn- square
  "Return the square of `n`."
  [n]
  (* n n))

(defn sum-of-squares
  "Returns the sum of the first `n` natural numbers squared i.e.
  (1^2 + 2^2 + 3^3 + ... + n^2)."
  [n]
  (->> (range 1 (inc n))
       (map square)
       (reduce +)))

(defn square-of-sum
  "Returns the sum of the first `n` natural numbers squared i.e.
  (1 + 2 + 3 + ... + n)^2."
  [n]
  (->> (range 1 (inc n))
       (reduce +)
       (square)))

(defn difference
  "Returns the difference between the [[square-of-sum]] and the [[sum-of-squares]]
  of n."
  [n]
  (- (square-of-sum n) (sum-of-squares n)))
