(ns cars-assemble)

(def base-production-rate 221)

(defn production-rate
  "Returns the assembly line's production rate per hour,
   taking into account its success rate"
  [speed]
  (let [base (* speed base-production-rate)]
    (cond
      (== speed 0) (* base  0.0)
      (<= speed 4) (* base  1.0)
      (<= speed 8) (* base  0.9)
      (== speed 9) (* base  0.8)
      (== speed 10) (* base  0.77))))


(defn working-items
  "Calculates how many working cars are produced per minute"
  [speed]
  (-> speed
      production-rate
      (/ 60)
      int))
