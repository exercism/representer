(ns rna-transcription)

(def dna-base-to-rna {\G \C, \C \G, \T \A, \A \U})

(defn get-throwing [map key]
  (do
    (assert (contains? map key))
    (map key)))

(defn to-rna [dna]
  (clojure.string/join (map #(get-throwing dna-base-to-rna %) dna))
)
