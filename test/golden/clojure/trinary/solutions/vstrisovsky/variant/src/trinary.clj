(ns trinary)

(defn to-decimal [b]
  (let [zero-letter (int \0)]
    (if (every? #{\0 \1 \2} b)
      (reduce #(+ (* 3 %1) (+ (int %2) zero-letter)) 0 b)
      0
    )
  )
)