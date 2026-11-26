(ns collatz-conjecture)
(defn collatz
  [num]
  (let [collatz-func (fn [x] (if (even? x)
                          (quot x 2)
                          (inc (* 3 x))))]
    (if (<= num 0)
      (throw (Exception. "only positive number allowed.")))
    (loop [count 0
           cnum num]
      (if (= cnum 1)
        count
        (recur (inc count) (collatz-func cnum))))
    ))
