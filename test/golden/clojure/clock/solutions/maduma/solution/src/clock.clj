(ns clock)

(defn clock->string [[hour minutes]]
  (format "%02d:%02d" hour minutes)
)

(defn clock [hours minutes]
  (let [min (+ (* 60 hours) minutes)
        back (if (neg? (rem min 60)) 1 0)]
    [(mod (- (quot min 60) back) 24) (mod min 60)]))

(defn add-time [[hour minutes] time]
  (clock hour (+ minutes time)))