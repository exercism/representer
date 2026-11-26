(ns darts)

(defn score "Calculates the score of a dart throw"
  [x y]
  (let [squared-distance (+ (* x x) (* y y))]
    (cond
      (<= squared-distance 1) 10    ;; center
      (<= squared-distance 25) 5    ;; middle
      (<= squared-distance 100) 1   ;; outer
      :else 0)))
