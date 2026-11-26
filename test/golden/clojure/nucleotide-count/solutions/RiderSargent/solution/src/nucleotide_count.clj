(ns nucleotide-count)

(defn nucleotide-counts [strand]
  (merge
    {\A 0, \T 0, \C 0, \G 0}
    (frequencies strand)))

(defn count-of-nucleotide-in-strand [nucleotide strand]
  {:pre [(contains? #{\A \T \G \C} nucleotide)]}
  ((nucleotide-counts strand) nucleotide))

