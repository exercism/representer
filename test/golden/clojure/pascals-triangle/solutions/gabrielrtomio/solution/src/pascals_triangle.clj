(ns pascals-triangle)


(defn- next-row [previous-row]
  (mapv + (cons 0 previous-row) (conj previous-row 0)))

(def triangle (iterate next-row [1]))