(ns robot-name
  (:require [clojure.string :as string])
  (:import [java.util UUID]))

(def robot-names (atom #{}))

(def letters (->> (range (int \A) (inc (int \Z)))
                  (map char)))

(def rand-letter #(rand-nth letters))
(def rand-digit #(rand-int 10))

(defn random-robot-name []
  (string/join "" (concat (repeatedly 2 rand-letter)
                          (repeatedly 3 rand-digit))))

(defn generate-robot-name! []
  (loop [new-name (random-robot-name)]
    (let [[old new] (swap-vals! robot-names conj new-name)
          added?    (not= old new)]
      (if added?
        new-name
        (recur (random-robot-name))))))

(defn robot []
  (atom
    {:uuid (UUID/randomUUID)
     :name (generate-robot-name!)}))

(defn robot-name [robot]
  (:name @robot))

(defn reset-name [robot]
  (let [new-name (generate-robot-name!)]
    (swap! robot assoc :name new-name)))
