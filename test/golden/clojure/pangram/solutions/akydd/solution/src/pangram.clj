(ns pangram
  (:require [clojure.string :as str]))

(defn pangram? [text]
  (->> text
      str/lower-case
      (re-seq #"[a-z]")
      distinct
      count
      (= 26)))

