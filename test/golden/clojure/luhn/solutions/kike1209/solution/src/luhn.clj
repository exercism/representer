(ns luhn
  (:require [clojure.string :as s]))

(defn convert [c]
  (let [x (* (- (int c) 48) 2)]
    (if (> x 9) (- x 9) x)))

(defn luhn [s]
  (->> (s/reverse s)
       (map #(if (even? %1) (- (int %2) 48) (convert %2)) (range (count s)))
       (reduce +)))
  
(defn valid? [s]
  (let [t (s/replace s " " "")]
    (not (or (re-find #"\D" t) (< (count t) 2) (pos? (rem (luhn t) 10))))))
