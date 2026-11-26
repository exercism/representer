(ns scrabble-score
  (:require [clojure.string :as str]))

(def score-letter
  (let [table-of-scores [["AEIOULNRST" 1]
                         ["DG"         2]
                         ["BCMP"       3]
                         ["FHVWY"      4]
                         ["K"          5]
                         ["JX"         8]
                         ["QZ"        10]]]
    (into {} (for [[ls s] table-of-scores
                   l ls
                   c [(str l) (str/lower-case l)]]
               [c s]))))

(defn score-word
  "Calculate a word's scrabble score."
  [word]
  (apply + (map (comp score-letter str) word)))
