(ns isogram)

(defn isogram? [s]
  (->> (clojure.string/lower-case s)
       (filter #(Character/isLetter %))
       (apply distinct?)))