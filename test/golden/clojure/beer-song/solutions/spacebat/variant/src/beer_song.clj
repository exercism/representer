(ns beer-song
  (:require [clojure.string :as string]))

(defn bottles [num]
  (if (= num 1)
    "bottle"
    "bottles"))

(defn amount [num]
  (cond
    (> num 0) (print-str num)
    (= num 0) "no more"))

(defn action [num]
  (cond
    (> num 1) "Take one down and pass it around"
    (= num 1) "Take it down and pass it around"
    (not= num 0) "Go to the store and buy some more"))

(defn verse
  "Returns the nth verse of the song."
  [num]
  (let [next (if (> num 0)
               (- num 1)
               99)]
    (format "%s %s of beer on the wall, %s %s of beer.\n%s, %s %s of beer on the wall.\n"
            (string/capitalize (amount num)) (bottles num)
            (amount num) (bottles num)
            (action num) (amount next) (bottles next))))

(defn sing
  "Given a start and an optional end, returns all verses in this interval. If
  end is not given, the whole song from start is sung."
  ([start]
   (sing start 0))
  ([start end]
   (string/join "\n"
                (for [num (reverse (range end (+ start 1)))]
                  (verse num)))))
