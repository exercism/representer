(ns largest-series-product)

(defn largest-product
  [span s]
  (cond
    (neg? span) (throw (IllegalArgumentException. "span must not be negative"))
    (> span (count s)) (throw (IllegalArgumentException. "span must not exceed string length"))
    (re-find #"[^\d]" s) (throw (IllegalArgumentException. "digits input must only contain digits")))
  (->> s
       (re-seq #"\d")
       (map #(Integer/parseInt %))
       (partition span 1)
       (map #(apply * %))
       (reduce max)))
