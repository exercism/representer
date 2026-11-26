(ns nth-prime)

(defn is-prime? [n]
    (cond
    (< n 2) false
    (= n 2) true
    (even? n) false
    :else (not-any? #(zero? (mod n %))
                    (range 3 (inc (int (Math/sqrt n))) 2))))

(defn nth-prime [n]
  (if (< n 1)
    (throw (IllegalArgumentException. "There is no zeroth prime"))
    (loop [count 0
           num 2]
      (if (not= count n)
        (- num 1)
        (if (is-prime? num)
          (recur (inc count) (inc num))
          (recur count (inc num)))))))
  
