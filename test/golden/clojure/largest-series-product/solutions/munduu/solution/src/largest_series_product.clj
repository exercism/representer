(ns largest-series-product)

(defn largest-product
  "Returns the largest product of any consecutive digits of length span in the string s."
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
