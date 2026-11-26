(ns nth-prime)
(def ^:private primes
  (cons 2 (filter #(not-any?
                    (comp zero? (partial rem %))
                    (range 3 (inc (Math/sqrt %)) 2))
                  (iterate (partial + 2) 3))))
(defn nth-prime [n]
  (when-not (pos? n)
    (throw (IllegalArgumentException.)))
  (nth primes (dec n)))