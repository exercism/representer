(ns two-fer)

(defn two-fer [& name] ;; <- arglist goes here
  (if-let [n (first name)]
    (str "One for " n ", one for me.")
    (str "One for you, one for me.")))
