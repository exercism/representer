(ns pig-latin
  (:require [clojure.string :as string]))

(defn translate-consonant-match [match]
  (str (match 2) (match 1) "ay"))

(defn translate-word [word]
  (let [qu-matches (re-find #"^(.?qu)(.+)" word)
        consonant-cluster-matches (re-find #"^([bcdfghjklmnprstvwxz]+)([aeiouy].+)" word)
        vowel-matches (re-find #"^([aeiou]|yt|xr)(.+)" word)]
    (cond
      ;; The order is important here, so that only words starting with consonants are
      ;; handled by the last three cases.
      vowel-matches (str word "ay")
      qu-matches (translate-consonant-match qu-matches)
      consonant-cluster-matches (translate-consonant-match consonant-cluster-matches)
      :else (str (subs word 1) (first word) "ay"))))

(defn translate [phrase]
  (string/join " "  (map translate-word (string/split phrase #" "))))
