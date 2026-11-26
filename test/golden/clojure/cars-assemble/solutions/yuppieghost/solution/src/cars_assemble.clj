(ns cars-assemble)

(def cars-per-hour 221)

(defn success-rate [speed]
  (condp <= speed
    10 0.77
    9 0.8
    5 0.9
    1 1.0
    0.0))


(defn production-rate
  [speed]
  (* speed cars-per-hour (success-rate speed)))
;; (defn production-rate
;;   "Returns the assembly line's production rate per hour,
;;    taking into account its success rate"
;;   [speed]
;;   (cond
;;     (= 0) 0.0
;;     (and (>= speed 1) (<= speed 4)) (* speed 221)
;;     (and (>= speed 5) (<= speed 8)) (* 0.9 (* speed 221))
;;     (= 9 speed) (* 0.8 (* speed 221))
;;     (= 10 speed) (* 0.77 (* speed 221))))

(defn working-items
  "Calculates how many working cars are produced per minute"
  [speed]
  (int (/ (production-rate speed) 60)))
