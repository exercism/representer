(ns difference-of-squares)

(defn sum-of-squares [num] ;; <- arglist goes here
  (reduce (fn [acc v] (+ acc (* v v))) (range 1 (inc num)))
)

(defn square-of-sum [num] ;; <- arglist goes here
  (let [s (reduce + (range 1 (inc num)))]
    (* s s)))

(defn difference [num] 
  (- (square-of-sum num) (sum-of-squares num))
)
