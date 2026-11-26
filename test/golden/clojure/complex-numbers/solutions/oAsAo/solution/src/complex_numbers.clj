(ns complex-numbers)

(defn sqr
  [x] (* x x))

(defn real [[a b]] ;; <- arglist goes here
  a
)

(defn imaginary [[a b]] ;; <- arglist goes here
  b
)

(defn abs [[a b]] ;; <- arglist goes here
  (Math/pow (+ (sqr a) (sqr b)) 0.5)
)

(defn conjugate [[a b]] ;; <- arglist goes here
  [a (- b)]
)

(defn add [[a b] [c d]] ;; <- arglist goes here
  [(+ a c) (+ b d)]
)

(defn sub [[a b] [c d]] ;; <- arglist goes here
  [(- a c) (- b d)]
)

(defn mul [[a b] [c d]] ;; <- arglist goes here
  [(- (* a c) (* b d)) 
   (+ (* b c) (* a d))]
)

(defn div [[a b] [c d]] ;; <- arglist goes here
  [(/ (+ (* a c) (* b d)) (+ (sqr c) (sqr d))) 
   (/ (- (* b c) (* a d)) (+ (sqr c) (sqr d)))]
)
