(ns robot-simulator
  (:require [clojure.string :as str]))

(defn robot [coordinates bearing]
  {:coordinates coordinates
   :bearing bearing}
)

(defn advance [{bearing :bearing, {x :x, y :y} :coordinates}]
  (case bearing
    :north {:x x, :y (inc y)}
    :east  {:y y, :x (inc x)}
    :south {:x x, :y (dec y)}
    :west  {:y y, :x (dec x)}
  )
)

(defn turn-right [bearing]
  (case bearing
    :north :east
    :east  :south
    :south :west
    :west  :north
  )
)

(defn turn-left [bearing]
  (case bearing
    :north :west
    :west  :south
    :south :east
    :east  :north
  )
)

(defn step [bot instruction]
  (case instruction
    \R (assoc bot :bearing (turn-right (:bearing bot)))
    \L (assoc bot :bearing (turn-left (:bearing bot)))
    \A (assoc bot :coordinates (advance bot))
    bot
  )
)

(defn simulate [instructions bot]
  (reduce step bot instructions)
)
