(ns sieve)

(defn sieve [n]
  (let [s (vec (repeat (inc n) true))]
    (loop [i 2 result s]
      (if (> i n)
        (nthrest (reduce-kv #(if (true? %3) (conj %1 %2) %1) [] result) 2)
        (recur (inc i)
               (loop [j (* 2 i) r result]
                 (if (> j n) r (recur (+ j i) (assoc r j false)))))))))