(ns triangle)

(defn is-valid? [& sides]
  (let [sides-sum (apply + sides)]
    (and (every? pos? sides)
         (every? #(< 0 (- sides-sum % %)) sides)))) ;; suma dwóch boków > trzeci

(defn equilateral? [& sides] ; równoboczny
  (and (pos? (first sides))
       (apply = sides)))

(defn isosceles? [& sides] ; równoramienny
  (and
   (apply is-valid? sides)
   (not (apply distinct? sides))))

(defn scalene? [& sides] ;; różnoboczny
  (and
   (apply is-valid? sides)
   (apply distinct? sides)))