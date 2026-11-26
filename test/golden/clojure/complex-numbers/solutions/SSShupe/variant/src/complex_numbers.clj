(ns complex-numbers)

(defn real [[a b]]
  (first [a b])
)

(defn imaginary [[a b]]
  (second [a b])
)

(defn bsqr [[a b]]
  (* -1 (Math/pow (imaginary [a b]) 2)))

(defn square [x]
  (* x x))

(defn abs [[a b]]
  (Math/abs (Math/sqrt (+ (square (real [a b])) (square (imaginary [a b]))))))

(defn conjugate [[a b]]
  [a (* -1 b)]
)

(defn add [[a b] [c d]]
  [(+ (real [a b]) (real [c d])) (+ (imaginary [a b]) (imaginary [c d]))]
)

(defn sub [[a b] [c d]]
  [(- (real [a b]) (real [c d])) (- (imaginary [a b]) (imaginary [c d]))]
)

(defn mul [[a b] [c d]]
  (let [aa (real [a b])
        bb (imaginary [a b])
        cc (real [c d])
        dd (imaginary [c d])]
  [(- (* aa cc) (/ bb dd)) (+ (* bb cc) (* aa dd))]))

(defn div [[a b] [c d]]
  (let [aa (real [a b])
        bb (imaginary [a b])
        cc (real [c d])
        dd (imaginary [c d])]
    [(double (/ (+ (* aa cc) (* bb dd)) (+ (square cc) (square dd)))) (double (/ (- (* bb cc) (* aa dd)) (+ (square cc) (square dd))))]))
