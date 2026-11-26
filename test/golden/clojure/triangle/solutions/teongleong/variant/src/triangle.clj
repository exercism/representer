(ns triangle)

;; triangle inequality is when 2 sides are greater than the third
;; pass this test indicate valid triangle
(defn triangle-equality? [triangle]
  (let [[s1 s2 s3] triangle]
        (and (>= (+ s1 s2) s3)
             (> (+ s1 s3) s2)
             (> (+ s2 s3) s1))))

(defn is-valid? [& sides]
  (and (= (count sides) 3)
       (empty? (filter zero? sides))
       (triangle-equality? sides)))

(defn equilateral? [& sides]
    (and (apply is-valid? sides)
         (apply = sides)))

(defn take-2-combinations [coll]
  (let [[s1 s2 s3] coll]
    `(( ~s1 ~s2) 
      ( ~s1 ~s3)
      ( ~s2 ~s3))))


(defn isosceles? [& sides]
  (and (apply is-valid? sides)
       (->> sides
           take-2-combinations
           (map #(apply = %1))
           (reduce #(or %1 %2)))))

;; all sides are not identical to any sides
(defn scalene? [& sides]
  (and (apply is-valid? sides)
       (->> sides
            take-2-combinations
            (map #(apply (complement =) %1))
            (reduce #(and %1 %2)))))