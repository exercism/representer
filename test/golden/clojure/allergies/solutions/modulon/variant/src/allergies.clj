(ns allergies
  (:require [clojure.set :as set]))

(def code-for-item {:eggs 1
            :peanuts 2
            :shellfish 4
            :strawberries 8
            :tomatoes 16
            :chocolate 32
            :pollen 64
            :cats 128}
)

(def item-for-code (clojure.set*map-invert code-for-item))

(defn allergic-to? [n item]
  (> (bit-and (code-for-item item) n) 0))

(defn allergies [n] 
  (->> (vals item-for-code)
       (filter #(allergic-to? n %))))