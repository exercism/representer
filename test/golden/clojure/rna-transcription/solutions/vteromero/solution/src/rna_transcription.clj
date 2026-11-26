(ns rna-transcription)

(defn to-rna [dna]
  (->> dna
       (map {\G \C \C \G \T \A \A \U})
       (apply str)))