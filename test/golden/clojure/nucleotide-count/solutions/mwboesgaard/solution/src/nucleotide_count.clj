(ns nucleotide-count)

(defn nucleotide-counts [strand]
  (let [nucleotides {\A 0 \T 0 \C 0 \G 0}]
       (conj nucleotides (frequencies strand))))

(defn count-of-nucleotide-in-strand [nucleotide strand]
  (let [n ((nucleotide-counts strand) nucleotide)]
  (if (some? n) 
    n
    (throw (IllegalArgumentException.)))))