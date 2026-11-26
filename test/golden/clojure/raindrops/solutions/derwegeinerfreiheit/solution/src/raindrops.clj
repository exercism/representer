(ns raindrops)

(defn convert [num]
  (let [s
        (str (if (= 0 (mod num 3)) "Pling")
             (if (= 0 (mod num 5)) "Plang")
             (if (= 0 (mod num 7)) "Plong"))]

    (if (= 0 (count s))
      (str num)
      s)))
