(ns armstrong-numbers)

(defn exp [num power]
  (reduce * (repeat power num)))

(defn calculate-armstrong [num power]
  (let [digit (mod num 10)]
    (if (= num 0) num
        (->> digit
             (#(exp % power))
             (+ (calculate-armstrong (/ (- num digit) 10) power))))))
  

(defn armstrong? [num]
  (= (calculate-armstrong num (count (str num))) num))

