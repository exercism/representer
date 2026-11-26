(ns matching-brackets
  (:require [clojure.string :as str]))

(def matching-pairs
  #{[\( \)]
   [\{ \}]
   [\[ \]]}
  )

(defn is-open-bracket? [char]
  (#{\( \{ \[} char))
(defn is-close-bracket? [char]
  (#{\) \} \]} char))

(defn check-brackets [stack text]
  (cond
    (empty? text) (empty? stack)
    (is-open-bracket? (first text)) (check-brackets (cons (first text) stack) (next text))
    (and (first stack) (matching-pairs [(first stack) (first text)])) (check-brackets (next stack) (next text))
    (is-close-bracket? (first text)) false
    :else (check-brackets stack (next text))
    )
  )

(defn valid? [text]                                         ;; <- arglist goes here
  (check-brackets [] (seq (str/trim text)))
  )
