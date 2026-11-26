(ns proverb)

(def v1 "For want of a ")
(def v2 " was lost.")
(def v3 "And all for the want of a ")

(defn verse [tuple]
  (str v1 (first tuple) " the " (second tuple) v2))

(defn recite [ls]
  (if (empty? ls) 
    ""
    (clojure.string/join "\n"
      (conj (vec (map #(verse %) (partition 2 1 ls)))
            (str v3 (first ls)".")))))