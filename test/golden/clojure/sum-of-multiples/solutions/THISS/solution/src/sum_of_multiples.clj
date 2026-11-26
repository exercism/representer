(ns sum-of-multiples)

(defn multiples-less-than-limit
  [limit]
  (fn [num]
    (loop [acc num
           res (transient [])]
      #_(prn num acc limit)
      (if (< acc limit)
        (recur (+ acc num) (conj! res acc))
        (persistent! res)))))

(defn sum-of-multiples [nums limit] ;; <- arglist goes here
      ;; for each num in nums add num to list while cur + num < limit
;;   once we have this new list we can sum the values in it
  (if (zero? (count nums))
    0
    (->> nums
         (mapcat (multiples-less-than-limit limit))
         set
         (reduce +))))

(comment
  (sum-of-multiples [3,5] 20)
  ;
  )