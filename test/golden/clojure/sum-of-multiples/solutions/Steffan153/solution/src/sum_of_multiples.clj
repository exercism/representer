(ns sum-of-multiples)

(defn sum-of-multiples [factors sum]
  (apply + (distinct (mapcat #(range % sum %) factors))))
