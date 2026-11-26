(ns cars-assemble)


(defn get-success-rate
  "determines the success rate and returns it as a percentage"
  [speed]

  (cond
    (= speed 0) (identity 0)
    (and (>= speed 1) (<= speed 4) ) (identity 100)
    (and (>= speed 5) (<= speed 8) ) (identity 90)
    (= speed 9) (identity 80)
    (= speed 10) (identity 77)

   )
  )


(defn production-rate
  "Returns the assembly line's production rate per hour,
   taking into account its success rate"
  [speed]
  (def car-per-hr 221)
  (def total-car-per-hr (* car-per-hr speed))
  (def success-per-rate (get-success-rate speed))

  (def prod-total (* total-car-per-hr success-per-rate))

  (def prod-rate (double (/ prod-total 100)) )

  (identity prod-rate)

  )

(defn working-items
  "Calculates how many working cars are produced per minute"
  [speed]
  (def car-per-hr 221)
                                        ; (def car-per-min () )
  (def total-car-per-min (int (/ (production-rate speed) 60)) )

  (identity total-car-per-min)
  )
