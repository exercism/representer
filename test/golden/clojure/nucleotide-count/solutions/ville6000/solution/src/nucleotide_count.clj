(ns nucleotide-count)

(def dna {\A 0, \T 0, \C 0, \G 0})

(defn nucleotide-counts [strand]
  (merge dna (frequencies strand)))

(defn count-of-nucleotide-in-strand [nucleotide strand]
  {:pre [(#{\A \C \G \T} nucleotide)]}
  (get (nucleotide-counts strand) nucleotide))
