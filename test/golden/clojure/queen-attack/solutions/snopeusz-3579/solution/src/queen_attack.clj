(ns queen-attack
  (:require [clojure.string :as str]))

(defn board-string [queens]
  (->> (reduce
        (fn [board [q xy]]
          (assoc-in board xy (first (str/upper-case (name q)))))
        (vec (repeat 8 (vec (repeat 8 \_))))
        queens)
       (map (fn [r] (str (str/join " " r) (System/lineSeparator))))
       str/join))

(defn can-attack [queens]
  (let [[wx wy] (:w queens)
        [bx by] (:b queens)]
    (or (= wx bx)
        (= wy by)
        (= (+ wx wy) (+ bx by))
        (= (- wx wy) (- bx by)))))