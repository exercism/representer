(ns sum-of-multiples)

(defn sum-of-multiples
  "Calculate the energy points awarded to players
  when they complete a level"
  [items level]
  (->> items
       (mapcat #(range % level %))
       (set)
       (apply +)))
