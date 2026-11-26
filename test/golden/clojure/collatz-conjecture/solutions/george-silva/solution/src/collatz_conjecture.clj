(ns collatz-conjecture)

(defn calc [number]
  (cond
    (odd? number) (+ 1 (* 3 number))
    :else (/ number 2)))

(defn collatz [num]
  (cond (= num 0) (0)
        (< num 0) (throw (Exception. "negativo no"))
        :else (count (take-while #(not= 1 %) (iterate calc num)))
    ))
