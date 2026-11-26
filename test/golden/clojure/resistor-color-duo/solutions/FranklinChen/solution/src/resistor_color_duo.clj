(ns resistor-color-duo)

(def color-map
  {"black" 0
   "brown" 1
   "red" 2
   "orange" 3
   "yellow" 4
   "green" 5
   "blue" 6
   "violet" 7
   "grey" 8
   "white" 9})

(defn resistor-value
  "Returns the resistor value based on the given colors"
  [colors]
  (+ (* 10 (color-map (first colors)))
     (color-map (second colors))))