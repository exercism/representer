(ns collatz-conjecture)

(defn collatz [num]
  (cond
    (= num 1) 0
    (< num 1) (throw "error")
    (even? num) (+ 1 (collatz (/ num 2)))
    :else (+ 1 (collatz (+ (* 3 num) 1)))))
