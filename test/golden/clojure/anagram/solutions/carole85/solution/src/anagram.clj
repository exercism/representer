(ns anagram
  (:require [clojure.string :as str]))

(defn string-split->map [word]
  (reduce (fn [acc letra]
            (merge-with + acc {letra 1})) {} (str/lower-case word)))

(defn anagrams-for [word words-list]
  (let [word-mapped (string-split->map word)]
    (->> words-list
         (filter #(not= (str/lower-case word) (str/lower-case %)))
         (filter #(= word-mapped (string-split->map %)))
         (into []))))