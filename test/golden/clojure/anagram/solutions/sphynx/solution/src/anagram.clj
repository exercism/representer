(ns anagram
  (:require [clojure.string :as str]))

(defn are-anagrams? [s1 s2]
  (let [x (str/lower-case s1)
        y (str/lower-case s2)]
    (and (not= x y)
         (= (sort x) (sort y)))))

(defn anagrams-for [str candidates]
  (filter (partial are-anagrams? str) candidates))