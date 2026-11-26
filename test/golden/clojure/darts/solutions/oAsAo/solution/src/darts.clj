(ns darts)

(defn score
  "Calculates the score of a dart throw"
  [x y]
  (let [dist (Math/sqrt (+ (* x x) (* y y)))]
    (cond
      (<= dist 1) 10
      (<= dist 5) 5
      (<= dist 10) 1
      :else 0)))
