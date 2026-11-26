(ns strain)

(defn retain [pred coll]
  (reduce (fn [acc v]
            (if (pred v)
              (conj acc v)
              acc))
          [] coll))

(defn discard [pred coll]
  (retain (complement pred) coll))