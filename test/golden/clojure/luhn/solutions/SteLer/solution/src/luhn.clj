(ns luhn)

(def exp #"[\d\s]+")
(def digit->int (zipmap "0123456789" (range 10)))
(def n->code (zipmap (range 10) (map #(let [d (* 2 %)] (if (> d 9) (- d 9) d)) (range 10))))

(defn valid? [s]
  (boolean (and (re-matches exp s)
                (let [clean (clojure.string/replace s #"\s" "")]
                  (and (> (count clean) 1)
                       (->> clean
                            (map digit->int)
                            reverse
                            (map-indexed (fn [idx d] (if (odd? idx) (n->code d) d)))
                            (reduce +)
                            (#(zero? (rem % 10)))))))))