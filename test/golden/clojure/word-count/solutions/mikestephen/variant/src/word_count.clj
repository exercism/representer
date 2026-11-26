(ns word-count
  (:require [clojure.string :as str]))

(defn word-count
  "Returns a map of the case-insensitive frequencies of words in a sentence"
  [s]
  (->> s
       (re-seq #"[A-Za-z]+\'[A-Za-z]+|[A-Za-z]+|[0-9]+")
       (map str*lower-case)
       frequencies))
