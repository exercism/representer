(ns minesweeper
  (:require [clojure.string :as str]))

(defn find-mines [board]
  (let [locations (for [row (range (count board))
                        col (range (count (first board)))
                        :when (= \* (get-in board [row col]))]
                    [row col])]
    (set locations)))

(defn safe-inc [x]
  (if x (inc x) 1))

(def offsets [[-1 -1] [-1 0] [-1 1] [0 -1] [0 1] [1 -1] [1 0] [1 1]])

(defn neighbors [loc]
  (mapv (partial mapv + loc) offsets))

(defn make-numbers [mines]
  (->> mines
       (mapcat neighbors)
       frequencies))

(defn parse-board [board]
  (str/split board #"\n"))

(defn draw [board]
  (let [parsed-board (parse-board board)
        mines (find-mines parsed-board)
        nums (make-numbers mines)]
    (->>
     (for [row (range (count parsed-board))]
       (for [col (range (count (first parsed-board)))]
         (let [loc [row col]]
           (cond
             (get mines loc) "*"
             (get nums loc) (str (get nums loc))
             :otherwise " "))))
     (map (partial str/join ""))
     (str/join "\n"))))
