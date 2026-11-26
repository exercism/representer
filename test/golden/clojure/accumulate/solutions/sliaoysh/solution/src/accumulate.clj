(ns accumulate)

(defn accumulate [f xs]
  (letfn [(impl [f xs acc]
              (if (empty? xs)
                  acc
                  (impl f (rest xs) (conj acc (f (first xs))))))]
      (impl f xs [])))
