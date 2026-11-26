(ns difference-of-squares)

(defn sum-of-squares [num] ;; <- arglist goes here
  ;; your code goes here
  (reduce + (map #(int (Math/pow % 2)) (range 1 (inc num)))))

(defn square-of-sum [num] ;; <- arglist goes here
  ;; your code goes here
  (int (Math/pow (reduce + (range 1 (inc num))) 2)))

(defn difference [num] ;; <- arglist goes here
  ;; your code goes here
  (- (square-of-sum num) (sum-of-squares num)))
