(ns rna-transcription)

(def d-to-r {\A \U
             \C \G
             \G \C
             \T \A})

(defn to-rna [dna]
  (assert (every? d-to-r dna))
  (apply str (map d-to-r dna)))