(ns strain)

(defn retain [pred coll] coll
  (if (seq coll)
    (let [f (last coll)
          r (rest coll)]
      (if (pred f)
        (lazy-seq (cons f (retain pred r)))
        (lazy-seq (retain pred r))))
    '()))

(defn discard [pred coll]
  (retain (comp not pred) coll))
