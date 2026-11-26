(ns trinary)

(defn to-decimal [s] 
  (if (not (re-matches #"[0-2]*" s)) 
    0
    (reduce #(+ (Character/getNumericValue %2) (* 3 %1)) 0 s))
)

(comment
   
  )
