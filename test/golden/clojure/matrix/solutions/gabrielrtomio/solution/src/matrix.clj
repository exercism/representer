(ns matrix)
(require '[clojure.string :as s])

(defn- to-matrix [s]
  (->> (s/split s #"\n")
    (mapv #(mapv Integer/parseInt (s/split % #"\s")))))

(defn get-row
  "Returns the i-th row of the matrix s"
  [s i]
    ((to-matrix s) (dec i))
  )

(defn get-column
  "Returns the i-th column of the matrix s"
  [s i]
  (let [matrix (to-matrix s)]
    (mapv #((matrix %) (dec i)) (range 0 (count matrix)))))
