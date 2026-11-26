(ns robot-simulator)

(defn robot [position facing]
  {:coordinates position :bearing facing}
)

(defn advance [{bearing :bearing :as rbt}]
    (case bearing
    :north (update-in rbt [:coordinates :y] inc)
    :east (update-in rbt [:coordinates :x] inc)
    :south (update-in rbt [:coordinates :y] dec)
    :west (update-in rbt [:coordinates :x] inc)))

(defn turn-right [facing]
  (case facing
    :north :east
    :east :south
    :south :west
    :west :north))

(defn turn-left [facing]
    (case facing
    :north :west
    :west :south
    :south :east
    :east :north))

(defn simulate [commands rbt]
  (let [cmd-seq (seq commands)
        cmd (first cmd-seq)
        cmd-rest (rest cmd-seq)
        rbt-next (case cmd
                   \A (advance rbt)
                   \L (update-in rbt [:bearing] turn-left)
                   \R (update-in rbt [:bearing] turn-right))]
    (if (empty? cmd-rest) rbt-next (recur (apply str cmd-rest) rbt-next))))