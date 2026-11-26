(ns robot-simulator)

(def r-cw { :north :east
            :east :south
            :south :west
            :west :north})

(def r-ccw {:north :west
            :east :north
            :south :east
            :west :south})

(defn advance [robot]
  (case (:bearing robot)  
    :north (update-in robot [:coordinates :y] inc)
    :east  (update-in robot [:coordinates :x] dec)
    :south (update-in robot [:coordinates :y] dec)
    :west  (update-in robot [:coordinates :x] dec)))

(defn execute [robot instruction]
  (case instruction
    \R (update robot :bearing r-cw)
    \L (update robot :bearing r-ccw)
    \A (advance robot)
  ))

(defn robot [coordinates bearing]
  (hash-map :coordinates coordinates :bearing bearing))

(defn simulate [instructions robot]
   (reduce execute robot instructions))
