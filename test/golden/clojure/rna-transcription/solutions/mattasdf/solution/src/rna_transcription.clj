(ns rna-transcription)

(def dna->rna {\G \C \C \G \T \A \A \U})

(defn to-rna
  [dna]
  {:pre [(every? dna->rna dna)]}
  (apply str (map dna->rna dna)))
