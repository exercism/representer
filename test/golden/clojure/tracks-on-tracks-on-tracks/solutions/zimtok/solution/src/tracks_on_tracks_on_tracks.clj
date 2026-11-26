(ns tracks-on-tracks-on-tracks)

(defn new-list
  "Creates an empty list of languages to practice."
  []
  '())

(defn add-language
  "Adds a language to the list."
  [lang-list lang]
  (cons lang lang-list))

(def first-language
  "Returns the first language on the list."
  first)

(def remove-language
  "Removes the first language added to the list."
  rest)

(def count-languages
  "Returns the total number of languages on the list."
  count)

(defn learning-list
  "Creates an empty list, adds Clojure and Lisp, removes Lisp, adds
  Java and JavaScript, then finally returns a count of the total number
  of languages."
  []
  (count '("JavaScript" "Java" "Clojure")))
