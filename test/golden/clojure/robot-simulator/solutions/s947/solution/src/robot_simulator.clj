(ns robot-simulator)

(defn robot [coord bearing]
  {:coordinates coord :bearing bearing}
)

(defn turn-right [bearing]
  (case bearing
    :north :east
    :east  :south
    :south :west
    :west  :north
    :error
    )
)

(defn turn-left [bearing]
  (case bearing
    :north :west
    :east  :north
    :south :east
    :west  :south
    :error
    )
)

(defn advance [input_bot]
  (let 
    [ {{x :x y :y} :coordinates bearing :bearing} input_bot ]
    (case bearing
      :north (robot {:x x       :y (+ y 1)} bearing)
      :south (robot {:x x       :y (- y 1)} bearing)
      :east  (robot {:x (+ x 1) :y y      } bearing)
      :west  (robot {:x (- x 1) :y y      } bearing)
      :error)
    )
)

(defn simulate [command input_bot]
  (case (first command)
    nil input_bot
    \R (simulate (drop 1 command) (assoc input_bot :bearing (turn-right (:bearing input_bot))))
    \L (simulate (drop 1 command) (assoc input_bot :bearing (turn-left (:bearing input_bot))))
    \A (simulate (drop 1 command) (advance input_bot))
    :error
    )
)