(ns beer-song)

(def plural-on-wall "%1$d bottles of beer on the wall, %1$d bottles of beer.")
(def single-on-wall "1 bottle of beer on the wall, 1 bottle of beer.")
(def none-on-wall "No more bottles of beer on the wall, no more bottles of beer.")
(def plural-take-down "Take one down and pass it around, %1$d bottles of beer on the wall.")
(def single-take-down "Take one down and pass it around, 1 bottle of beer on the wall.")
(def last-take-down "Take it down and pass it around, no more bottles of beer on the wall.")
(def go-to-store "Go to the store and buy some more, 99 bottles of beer on the wall.")

(defn wall-line [n]
  (cond
    (> n 1) (format plural-on-wall n)
    (= n 1) single-on-wall
    (zero? n) none-on-wall))

(defn down-line [n]
  (cond
    (> n 2) (format plural-take-down (dec n))
    (= n 2) single-take-down
    (= n 1) last-take-down
    (zero? n) go-to-store))

(defn verse [n]
  (str (wall-line n) \newline (down-line n) \newline))

(defn sing
  ([n] (sing n 0))
  ([n e] (->> (map verse (range n (dec e) -1))
              (interpose \newline)
              (apply str))))