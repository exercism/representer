(ns pangram
  (:require [clojure.string :as str]))

(defn pangram? [s] ;; <- arglist goes here
  ;; your code goes here
  (->> s
       str/lower-case
       (re-seq #"[a-z]")
       set ;date is function
       count
       (= 26)))
