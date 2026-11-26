(ns sum-of-multiples)

(defn sum-of-multiples
  "Takes `items` <list: base values of magical items found> and 
   `level` <int: level completed>. Using the rules provided, 
   computes and returns total energy points."
  [items level]
  (->> items
       (mapcat #(range % level %))
       set
       (apply +)))
