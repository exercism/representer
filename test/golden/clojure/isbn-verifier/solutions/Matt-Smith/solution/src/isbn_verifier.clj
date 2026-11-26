(ns isbn-verifier)

(defn isbn? [isbn]
  (let [coll (re-seq #"\d|X$" isbn)]
    (cond 
      (not= 10 (count coll)) false
      (not= coll (re-seq #"[^-]" isbn)) false
      :else (->> coll
              (map #(if (= "X" %) 10 (Integer/parseInt %)))
              (reverse)
              (reduce #(conj %1 (* %2 (inc (count %1)))) [])
              (reduce +)
              (#(zero? (mod % 11))))))) 
