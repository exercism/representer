(ns bob
  (:require [clojure.string :as str]))

(defn question? [s] (str/ends-with? s "?" ))
(defn all-caps? [s] (and (= s (str/upper-case s)) (boolean (re-matches #".*[A-Z]+.*" s))))

(defn response-for [s] ;; <- arglist goes here
  ;; your code goes here
  (let [s (str/trim s)]
    (cond 
      (and (question? s) (all-caps? s)) "Calm down, I know what I'm doing!"
      (question? s) "Sure."
      (all-caps? s) "Whoa, chill out!"
      (str/blank? s) "Fine. Be that way!"
      :else "Whatever."
      )
    )
)
