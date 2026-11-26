(ns tracks-on-tracks-on-tracks)

(def new-list
  "Creates an empty list of languages to practice."
list)

(def add-language
  "Adds a language to the list."
  conj)

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
  (-> (new-list)
    (add-language "Clojure")
    (add-language "Lisp")
    (remove-language)
    (add-language "Java")
    (add-language "JavaScript")
    count-languages)
  )
