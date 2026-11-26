(ns beer-song
  (:require [clojure.string :as st]))

(defn verse
  "Returns the nth verse of the song."
  [num]
  (case num
    2 "2 bottles of beer on the wall, 2 bottles of beer.
Take one down and pass it around, 1 bottle of beer on the wall.\n"
    1 "1 bottle of beer on the wall, 1 bottle of beer.
Take it down and pass it around, no more bottles of beer on the wall.\n"
    0 "No more bottles of beer on the wall, no more bottles of beer.
Go to the store and buy some more, 99 bottles of beer on the wall.\n"
    (str num " bottles of beer on the wall, " num  " bottles of beer.
Take one down and pass it around, " (dec num) " bottles of beer on the wall.\n")))

(defn sing
  "Given a start and an optional end, returns all verses in this interval. If
  end is not given, the whole song from start is sung."
  ([start]
   (sing start 0))
  ([start end]
   (->> (range start (dec end) -1)
        (map verse)
        (st/join "\n"))))

(comment
  (verse 10)
  (sing 10)
  (sing 10 8)
  (range 10 0 -1)
  (reverse (range 0 10))
  (doseq [x (reverse (range 0 (inc 10)))]
    (prn x))
  ;
  )

;; cool use of multi methods

;; (defmulti beers (fn [x] x))
;; (defmethod beers 0 [x]
;;   "No more bottles of beer on the wall, no more bottles of beer.\nGo to the store and buy some more, 99 bottles of beer on the wall.\n")
;; (defmethod beers 1 [x]
;;   "1 bottle of beer on the wall, 1 bottle of beer.\nTake it down and pass it around, no more bottles of beer on the wall.\n")
;; (defmethod beers 2 [x]
;;   "2 bottles of beer on the wall, 2 bottles of beer.\nTake one down and pass it around, 1 bottle of beer on the wall.\n")
;; (defmethod beers :default [x]
;;   (str x " bottles of beer on the wall, "
;;        x " bottles of beer.\nTake one down and pass it around, "
;;        (- x 1) " bottles of beer on the wall.
;; "))
;; (defn sing
;;   ([n]
;;    (sing n 0))
;;   ([n x]
;;    (join "\n" (map beers (range n (- x 1) -1)))))