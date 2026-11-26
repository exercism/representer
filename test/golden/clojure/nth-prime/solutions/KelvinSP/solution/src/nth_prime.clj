(ns nth-prime)

(defn prime? [n]
  (let [divisors (range 2 (inc (int (Math/sqrt n)))) 
        remainders (map #(mod n %) divisors)]
    (not-any? #(= % 0) remainders)))

(defn primes
    ([n] (take n (filter prime? (iterate inc 2))))
    ([n f] (map f (primes n))))

(defn nth-prime [n]
  (if (= n 0)
    (throw (IllegalArgumentException. "Invalid value"))
    (last (primes n))))
