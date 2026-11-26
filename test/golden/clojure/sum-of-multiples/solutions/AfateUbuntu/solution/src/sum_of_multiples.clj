(ns sum-of-multiples)

(defn sum-of-multiples [magic-nums level] ;; <- arglist goes here
      ;; your code goes here
  (apply +
         (set (mapcat #(range % level %) magic-nums))))

