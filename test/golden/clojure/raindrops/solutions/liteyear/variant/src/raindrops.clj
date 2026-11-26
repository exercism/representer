(ns raindrops)

(defn div-by? [num div] (zero? (mod num div)))

(defn convert [num]
  (let [ret (str
             (if (div-by? num 4) "Pling" "")
             (if (div-by? num 5) "Plang" "")
             (if (div-by? num 7) "Plong" ""))]
    (if (empty? ret) (str num) ret))
)
