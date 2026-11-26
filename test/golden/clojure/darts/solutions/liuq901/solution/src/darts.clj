(ns darts)

(defn score
  "Calculates the score of a dart throw"
  [x y]
  ;; function body
  (let [dis (Math/sqrt (+ (* x x) (* y y)))]
    (cond
      (<= dis 1) 10
      (<= dis 5) 5
      (<= dis 10) 1
      :else 0)))
