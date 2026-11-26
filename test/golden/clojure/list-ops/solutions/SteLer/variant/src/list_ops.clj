(ns list-ops)

(defn append 
  [coll1 coll2]
  (loop [l1 coll1 l2 coll2]
    (if (empty? l2) l1 (recur (conj l1 (first l2)) (rest l2)))))

(defn concatenate 
  [colls]
  (loop [acc [] ll colls]
    (if (empty? ll) acc (recur (append acc (first ll)) (rest ll)))))

(defn select-if
  [pred coll]
  (loop [acc [] l coll]
    (cond
      (empty? l) acc
      (pred (first l)) (recur (conj acc (first l)) (rest l))
      :else (recur acc (rest l)))))

(defn length 
  [coll]
  (loop [n 0 l coll]
    (if (empty? l) n (recur (inc n) (rest l)))))

(defn apply-to-each 
  [f coll]
  (loop [acc [] l coll]
    (if (empty? l) acc (recur (conj acc (f (first l))) (rest l)))))

(defn foldl 
  [f coll acc]
  (loop [l coll a acc]
    (if (empty? l) a (recur (rest l) (f a (first l))))))

(defn foldr
  [f coll acc]
  (loop [l coll a acc]
    (if (empty? l) a (recur (subvec l 1 (dec (length l))) (f a (last l))))))

(defn reverse-order 
  [coll]
  (foldr conj coll []))