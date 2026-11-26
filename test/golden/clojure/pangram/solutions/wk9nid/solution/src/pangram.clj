(ns pangram
  (:require [clojure.string :as str]))

(defn pangram? [s]
  (->> (str/lower-case s)
       (re-seq #"[a-z]")
       distinct
       count
       (= 26)))