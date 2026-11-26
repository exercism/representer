(ns cars-assemble)

(def cars-per-hour 221)
(def minutes-per-hour 60)

(defn success-rate
  [speed]
  (cond (and (>= speed 1) (<= speed 4)) 1.0
        (and (>= speed 5) (<= speed 8)) 0.9
        (= 9 speed)                     0.8
        (= 10 speed)                    0.77
        :else                           0.0))

(defn production-rate
  "Returns the assembly line's production rate per hour,
   taking into account its success rate"
  [speed]
  (double (* speed
             (success-rate speed)
             cars-per-hour)))

(defn working-items
  "Calculates how many working cars are produced per minute"
  [speed]
  (int (/ (production-rate speed) minutes-per-hour)))
