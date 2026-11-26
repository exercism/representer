(ns collatz-conjecture)

(defn collatz [num] ;; <- arglist goes here
  (do
    (if (< num 0) (throw (Throwable. "Number is too low.")) )
    (loop [n num counter 0]
      (if (= 1 n)
        counter
        (recur (if (even? n) (/ n 2) (+ 1 (* 3 n))) (inc counter))
        )
      ))
  )
