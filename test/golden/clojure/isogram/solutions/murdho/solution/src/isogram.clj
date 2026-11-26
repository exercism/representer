(ns isogram)

(defn isogram? [s]
  (->> s
       (clojure.string/lower-case)
       (filter #(Character/isLetter %))
       (apply distinct?)))