(ns pangram
  [:require [clojure.string :as str]])

(defn pangram? [sentence]
  (->> sentence
       (str/lower-case)
       (re-seq #"[a-z]")
       set
       count
       (= 26)))
