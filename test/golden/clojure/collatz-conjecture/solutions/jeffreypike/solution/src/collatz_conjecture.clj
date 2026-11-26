(ns collatz-conjecture)

(defn collatz 
  ([n iterations]
    (if (= n 1)
      iterations
      (if (even? n)
        (collatz (/ n 2) (+ iterations 1))
        (collatz (+ (* 3 n) 1) (+ iterations 1)))))
  ([n]
   (if (< n 0)
     (throw (IllegalArgumentException. "n must be nonnegative")))
     (collatz n 0)))
