(ns tracks-on-tracks-on-tracks)

(defn new-list
  "Creates an empty list of languages to practice."
  []
  '())

(defn add-language
  "Adds a language to the list."
  [lang-list lang]
  (list* lang lang-list))

(defn first-language
  "Returns the first language on the list."
  [lang-list]
  (first (list* lang-list)))

(defn remove-language
  "Removes the first language added to the list."
  [lang-list]
  (let [[_ & others] lang-list]
    (list* others)))

(defn count-languages
  "Returns the total number of languages on the list."
  [lang-list]
  (count lang-list))

(defn learning-list
  "Creates an empty list, adds Clojure and Lisp, removes Lisp, adds
  Java and JavaScript, then finally returns a count of the total number
  of languages."
  []
  (let [l (new-list)
        l (add-language l "Clojure")
        l (add-language l "Lisp")
        l (remove-language l)
        l (add-language l "Java")
        l (add-language l "JavaScript")
        n (count-languages l)] n))
