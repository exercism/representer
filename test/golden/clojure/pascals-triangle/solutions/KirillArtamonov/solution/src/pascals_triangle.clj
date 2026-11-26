(ns pascals-triangle)

(defn- next-row [row] (mapv + (cons 0 row) (conj row 0)))

(def triangle (iterate next-row [1]))
