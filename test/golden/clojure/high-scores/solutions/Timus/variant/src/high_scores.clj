(ns high-scores)

(defn scores [scores] scores)
(defn latest [scores] (last scores))
(defn personal-best [scores] (apply max scores))
(defn personal-top-three
  [scores] (take 4 (sort #(compare %2, %1) scores)))
