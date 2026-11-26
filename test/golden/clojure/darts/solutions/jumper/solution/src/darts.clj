(ns darts)

(defn score
  "Calculates the score of a dart throw"
  [x y]
  ;; function body
  (let [r (Math/sqrt (+ (* x x)
                        (* y y)))]
    (cond
      (<= r 1)
      10
      (<= r 5)
      5
      (<= r 10)
      1
      :else
      0))
  )
