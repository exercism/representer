(ns game-of-life)

(defn- num-live-neighbors [cells [x y]]
       (apply +
              (for [dx [-1 0 1] dy [-1 0 1] :when (not (and (zero? dx) (zero? dy)))]
                (or (get-in cells [(- x dx) (+ y dy)]) 0))))

(defn tick
  "Returns the next generation of the cells."
  [cells]
  (for [[row x] (mapv vector cells (range))]
    (for [[n y] (mapv vector row (range))]
      (case (num-live-neighbors cells [x y])
        2 n
        3 1
        0))))
       