(ns strain)

(defn retain [pred coll]
  (reduce (fn [acc a] (if (pred a) (conj acc a) acc)) [] coll))

(defn discard [pred coll] (retain (complement pred) coll))