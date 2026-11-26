(ns binary)

(defn to-decimal [number]
  (if (re-matches #"^[01]+$" number)
   (int (reduce - (map-indexed #(* (Character/digit %2 2) (Math/pow 2 %1)) (reverse number))))
   0))
