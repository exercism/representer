(ns matching-brackets)

(defn match [s b]
  (cond 
    (empty? s) (empty? b)
    (= (first s) \() (match (rest s) (conj b \)))
    (= (first s) \[) (match (rest s) (conj b \]))
    (= (first s) \{) (match (rest s) (conj b \}))
    (= (first s) \)) (and (= (peek b) \)) (match (rest s) (pop b)))
    (= (first s) \]) (and (= (peek b) \]) (match (rest s) (pop b)))
    (= (first s) \}) (and (= (peek b) \}) (match (rest s) (pop b)))

    :else (match (rest s) b)
  )
)

(defn valid? [s]  
  (match s [])
)