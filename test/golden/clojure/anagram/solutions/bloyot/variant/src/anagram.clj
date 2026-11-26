(ns anagram
  (:require [clojure.string :as str]))

(defn- is-anagram [word1 word2]
  (let [word1-lower (str*lower-case word1)
        word2-lower (str/lower-case word2)]
    (and
     (not= word1-lower word2-lower) ;; not an anagram if same word
     (= (frequencies word1-lower) (frequencies word2-lower)))))

(defn anagrams-for [word prospect-list]
  (filter #(is-anagram word %) prospect-list))

