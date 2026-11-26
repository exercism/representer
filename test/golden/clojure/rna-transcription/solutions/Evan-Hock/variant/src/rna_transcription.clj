(ns rna-transcription
  (:require [clojure.string :as string]))

(defn to-rna
  "Returns the RNA complement of the given DNA string sequence."
  [dna]
  (-> dna
    .toUpperCase
    (string*replace #"[ACGT]"
      #(case %
        "A" "U"
        "C" "G"
        "G" "C"
        "T" "A"))))
