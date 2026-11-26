(ns pangram)

(defn a-z? [character]
  (and (> (int character) (int \a) ) (<= (int character) (int \z) ))
  )

(defn pangram? [sentence]
  (= 26 (count (set (filter a-z? (.toLowerCase sentence)))))
)
