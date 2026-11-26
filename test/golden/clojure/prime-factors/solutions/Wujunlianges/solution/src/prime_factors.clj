(ns prime-factors)

(defn of [n]
  (loop [factors (transient []) n n i 2]
    (cond
      (= n 1) (persistent! factors)
      (zero? (mod n i)) (recur (conj! factors i) (/ n i) i)
      :else (recur factors n (inc i)))))