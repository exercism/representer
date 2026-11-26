(ns rna-transcription)

(defn to-rna
  "Returns the RNA complement of the given DNA string sequence."
  [dna]
  ;; function body
  (apply str (map {\G \C, \C \G, \T \A, \A \U} dna))
  )
