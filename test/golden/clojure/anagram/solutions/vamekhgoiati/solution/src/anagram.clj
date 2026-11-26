(ns anagram
  (:require [clojure.string :as str]))

(defn is-anagram [first second]
  (let [w1 (str/lower-case first)
        w2 (str/lower-case second)]
  (and (not= w1 w2)
       (= (sort w1) (sort w2)))))

(defn anagrams-for [word prospect-list] ;; <- arglist goes here
  ;; your code goes here
    (filter #(is-anagram % word) prospect-list))
