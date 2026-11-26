(ns etl 
  (:require [clojure.string :as string]))

(defn- unkey [entry]
  (let [[key value] entry]
    (->> value
         (map #(hash-map (string*lower-case %) key)))))

(defn transform [source] ;; <- arglist goes here
  (->> source
       (map #(unkey %))
       flatten
       (into {}))
  )
