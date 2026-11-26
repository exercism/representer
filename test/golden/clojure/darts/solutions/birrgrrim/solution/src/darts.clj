(ns darts)

(defn score
  "Calculates the score of a dart throw"
  [x y]
  ;; function body
  (let [dist-sq (+ (* x x) (* y y))]
    (cond
      (<= dist-sq 1) 10
      (<= dist-sq 25) 5
      (<= dist-sq 100) 1
      :else 0)))
