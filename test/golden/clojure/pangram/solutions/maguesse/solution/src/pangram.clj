(ns pangram
  (:require [clojure.string :as str]))

(defn pangram? [s] ;; <- arglist goes here
  (= 26 (count (set (re-seq #"[a-z]" (str/lower-case s))))))