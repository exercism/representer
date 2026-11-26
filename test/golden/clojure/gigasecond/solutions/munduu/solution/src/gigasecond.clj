(ns gigasecond)
(defn from [y m d]
  (let [gigadate (.plusSeconds (java.time.LocalDateTime/of y m d 0 0) 1000000000)]
    [(.getYear gigadate) (.getMonthValue gigadate) (.getDayOfMonth gigadate)])) 