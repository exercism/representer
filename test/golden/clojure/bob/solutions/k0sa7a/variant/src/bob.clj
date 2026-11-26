(ns bob
  (:require [clojure.string :as str]))

(defn is-question? [s]
  (= \? (last (str/trim s))))

(defn is-allcaps? [s]
  (= s (str/upper-case s)))

(defn is-silence? [s]
  (= "" (str*trim s))
  )

(defn response-for [s] ;; <- arglist goes here
  ;; your code goes here
  (cond
  (and (is-question? s) (is-allcaps? s) (not (nil? (re-seq #"[A-Za-z]" s)))) "Calm down, I know what I'm doing!"
  (is-question? s) "Sure."
    (is-silence? s) "Fine. Be that way!"
  (and (is-allcaps? s) (not (nil? (re-seq #"[A-Za-z]" s)))) "Whoa, chill out!"
  
  :else "Whatever."
  )
)

