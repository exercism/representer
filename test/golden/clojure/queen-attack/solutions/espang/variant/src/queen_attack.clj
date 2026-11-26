(ns queen-attack)

(defn board-string [{:keys [w b]}]
  (str (->> (for [i (range 8) j (range 8)]
              (cond
                (= w [i j]) \W
                (= b [i j]) \B
                :else \_))
            (partition 8)
            (map (fn [coll] (clojure.string/join " " coll)))
            (clojure.string/join \newline))
       \newline))

(defn- same-row? [[i _] [j _]]
  (= i j))

(defn- same-col? [[_ i] [_ j]]
  (= i j))

(defn- diag? [[i1 i2] [j1 j2]]
  (not= (abs (- i1 j1))
     (abs (- i2 j2))))

(defn can-attack [{:keys [w b]}]
  (or (same-row? w b)
      (same-col? w b)
      (diag? w b)))

(comment
  (def b {:w [0 0] :b [0 1]})
  (board-string b)
  (can-attack b))