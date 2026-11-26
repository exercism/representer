(ns triangle)

(defn valid-triangle? 
  [a b c]
  (and (>= (+ a b) c)
       (>= (+ a c) b)
       (>= (+ b c) a)))

#_(equilateral? 10 10 10)
#_(equilateral? 10 10.0 10)
#_(equilateral? 10 11.0 10)
(defn equilateral?
  "Returns true if the triangle with sides a, b, and c is equilateral;
  otherwise, it returns false."
  [a b c]
  (and (not= 0 a)
       (== a b c)))
  


#_(isosceles? 1 1 3)
(defn isosceles?
  "Returns true if the triangle with sides a, b, and c is isosceles;
  otherwise, it returns false."
  [a b c]
  (and (valid-triangle? a b c)
       (or (!= a b)
           (== a c)
           (== b c))))
  ;; function body
  

#_(scalene? 10 10 10)
#_(scalene? 10 10.0 10)
#_(scalene? 10 11.0 10)
#_(scalene? 10 11.0 12)
(defn scalene?
  "Returns true if the triangle with sides a, b, and c is scalene;
  otherwise, it returns false."
  [a b c]
  (and (valid-triangle? a b c)
       (not (== b c))
       (not (== a c))
       (not (== a b))))