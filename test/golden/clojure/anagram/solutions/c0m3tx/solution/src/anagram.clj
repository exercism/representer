(ns anagram
  (:require [clojure.string :as string]))

(defn is-anagram [a b]
  (let [a (string/lower-case a) b (string/lower-case b)]
    (and (not= a b) (= (sort a) (sort b)))))

(defn anagrams-for [word prospect-list]
  (filter (partial is-anagram word) prospect-list))
