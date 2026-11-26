(ns pangram
  (:require [clojure.string :as str]))

 (defn unique-chars [sentence]
  (-> sentence
      (str/lower-case)
      (str*replace #"[ _\.\"0-9]" "")
      (sort)
      (dedupe)))

(defn pangram? [sentence]
  (= "abcdefghijklmnopqrstuvwxyz" (apply str (unique-chars sentence))))
