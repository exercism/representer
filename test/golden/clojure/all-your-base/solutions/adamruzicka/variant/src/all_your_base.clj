(ns all-your-base)

(defn- to-base10 [base input]
  (reduce #(+ (* base %1) %2) 0 input))

(defn- from-base10 [base input]
  (loop [input input
         digits '()]
    (if (> base input)
      (conj digits input)
      (recur (quot input base) (conj digits (mod input base))))))

(defn- between? [lower upper]
  (fn [x] (and (> x lower) (< x upper))))

(defn convert [source-base digits target-base]
  (when (and (> source-base 1)
             (> target-base 1)
             (seq digits)
             (every? (between? 0 source-base) digits))
    (->> digits
         (to-base10 source-base)
         (from-base10 target-base))))
