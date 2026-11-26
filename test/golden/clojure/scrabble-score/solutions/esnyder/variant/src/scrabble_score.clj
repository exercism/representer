(ns scrabble-score
  (:require [clojure.string :as str]))

(def scoring-table
  {1 [\A \E \I \O \U \L \N \R \S \T]
   2 [\D \G]
   3 [\B \C \M \P]
   4 [\F \H \V \W \Y]
   5 [\K]
   8 [\J \X]
   10 [\Q \Z]})

(def letter-values
  (reduce (fn [acc [value letters]]
            (merge acc (zipmap letters (repeat value))))
          {}
          scoring-table))

(defn score-letter [l]
  (get letter-values l 0))

(defn score-word [word]
  (reduce - (map score-letter (str/upper-case word))))
