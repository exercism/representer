(ns roman-numerals)

(defn generalised-formula [value one fifth tenth]
  (cond
    (< value 4) (apply str (repeat value one))
    (= value 4) (str one fifth)
    (= value 5) (str fifth)
    (and (> value 5) (< value 9)) (str fifth (generalised-formula (- value 5) one fifth tenth))
    (= value 9) (str one tenth))
  )

(def place-to-roman
  {
   1 {:one \I :fifth \V :tenth \X}
   10 {:one \X :fifth \L :tenth \C}
   100 {:one \C :fifth \D :tenth \M}
   1000 {:one \M :fifth \V :tenth \X}})

(defn numerals [n]
  (let [size (int (java.lang.Math/log10 n))
        place (int (java.lang.Math/pow 10 size))
        char-set (get place-to-roman place)]
    (str (generalised-formula (int (/ n place)) (:one char-set) (:fifth char-set) (:tenth char-set))
         (if (zero? (mod n place)) "" (numerals (mod n place)))))
)
