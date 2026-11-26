(ns spiral-matrix)

(defn spiral [n & start]
  (let [st (if (nil? start) 1 (first start))]
    (if (zero? n) '()
        (conj (map-indexed #(concat (reverse %2)
                                    (list (+ %1 n st)))
                           (reverse (spiral (dec n)
                                            (+ st -1 (* 2 n)))))
              (take n (iterate inc st))))))
