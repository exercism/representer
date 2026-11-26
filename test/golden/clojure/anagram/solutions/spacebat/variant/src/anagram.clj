(ns anagram
  (:require [clojure.string :as str]))

(defn anagrams-for [word prospect-list]
  (let [lower-word (str/lower-case word)
        sorted-lower-word (sort lower-word)]
    (letfn [(anagram? [candidate]
              (let [lower-candidate (str/lower-case candidate)
                    sorted-lower-candidate (sort lower-candidate)]
                (and (= lower-word lower-candidate)
                     (= sorted-lower-word sorted-lower-candidate))))]
      (filter anagram? prospect-list))))
