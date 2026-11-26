(ns gigasecond)

(defn from
  [y m d]
  (let [date (.plusSeconds (java.time.LocalDateTime/of y m d 0 0) 1000000000)]
    [(.getYear date) (.getMonthValue date) (.getDayOfMonth date)]))
