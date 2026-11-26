(ns proverb (:require [clojure.string :as s]))

(defn recite [items]
  (str (->>
        (map
         (fn [[a b]] (format "For want of a %s the %s was lost.\n" a b))
         (partition 2 1 items))
        s/join)
       (if-let [it (first items)]
         (format "And all for the want of a %s." it))))