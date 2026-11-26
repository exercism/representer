(ns all-your-base)

(defn put-together [base digits]
  (loop [acc 0 b 1 d (reverse digits)]
    (if (empty? d) acc
      (recur (+ acc (* b (first d))) (* b base) (rest d)))))

(defn take-apart [base number]
  (loop [acc '() n number]
    (if (zero? n) acc
      (recur (conj acc (rem n base)) (quot n base)))))

(defn convert [inbase digits outbase] ;; <- arglist goes here
  (cond
    (<= inbase 1) nil
    (<= outbase 1) nil
    (zero? outbase) '(0)
    (empty? digits) '()
    (some neg? digits) nil
    (every? zero? digits) '(0)
    (some (partial <= inbase) digits) nil
    :else (take-apart outbase (put-together inbase digits))))
