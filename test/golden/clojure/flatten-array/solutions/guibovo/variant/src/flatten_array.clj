(ns flatten-array)

(defn flatten
  "Flattens the given sequential collection.
  Nil values are excluded from the result."
  [coll]
  (reduce 
    (fn [acc cv] 
      (cond
        (or (seqable? cv) (not (string? cv))) (concat acc (flatten cv))
        :else (concat acc [cv])))
    []
    coll))


(comment
  (def c [1 [[[2]]] nil [nil 4 [5]] nil 6 "54"])
  (identity c)
  (flatten c)
  (seq? (first c))
  (cons (first c))
  (seq? []))
  

