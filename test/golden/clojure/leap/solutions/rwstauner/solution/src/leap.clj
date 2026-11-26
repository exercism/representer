(ns leap)

(defn divisible-by?
  [x y]
  (= 0 (mod x y)))

(defn leap-year?
  [year]
  (let [ydb? (partial divisible-by? year)]
    (and
      (ydb? 4)
      (or
        (not (ydb? 100))
        (ydb? 400)
        ))))