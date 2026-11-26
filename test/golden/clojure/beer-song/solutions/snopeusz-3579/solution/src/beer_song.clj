(ns beer-song
  (:require clojure.string))

(defn verse
  "Returns the nth verse of the song."
  [nb]
  (let [make-bottles-str (fn [n] (str
                              (if (zero? n) "no more" (str n))
                              " bottle" (when-not (= n 1) "s")))
        bottles-str (make-bottles-str nb)
        next-bottles-str (make-bottles-str (mod (dec nb) 100))]
    (str
     (clojure.string/capitalize bottles-str)
     " of beer on the wall, "
     bottles-str " of beer."
     \newline
     (if (zero? nb)
       "Go to the store and buy some more, "
       (str "Take " (if (= nb 1) "it" "one") " down and pass it around, "))
     next-bottles-str " of beer on the wall.\n")))

(defn sing
  "Given a start and an optional end, returns all verses in this interval. If
  end is not given, the whole song from start is sung."
  ([start]
   (sing start 0))
  ([start end]
   (->> (range start (dec end) -1)
        (map verse)
        (clojure.string/join \newline))))