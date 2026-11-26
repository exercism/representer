(ns yacht)

(defn yacht-score [dice]
  (if (every? #(= % (first dice)) dice)
    50
    0))

(defn numeric-score [dice n]
  (* (count (filter #(= % n) dice))
     n))

(defn groups [l]
  (loop [res {}
         i 0
	 curr (first l)]

    (if (>= i (count l))
	res
	(recur (assoc res curr (+ (get res curr 0) 1)) 
	       (+ i 1) 
               (get l (+ i 1))))))

(defn full-house-score [dice]
  (let [gs (groups dice)]
    (if (= (sort (vals gs)) [2, 3])
	(reduce + 0 dice)
	0)))

(defn four-of-a-kind-score [dice]
  (let [gs (groups dice)
	sorted (sort #(compare (second %2) (second %1)) gs)
	[highest-key highest-val] (first sorted)]

    (if (>= highest-val 4)
	(* highest-key 4)	
	0)))

(defn little-straight-score [dice]
  (if (= (sort dice) [1, 2, 3, 4, 5])
    30
    0))

(defn big-straight-score [dice]
  (if (= (sort dice) [2, 3, 4, 5, 6])
    30
    0))

(defn choice-score [dice]
  (reduce + 0 dice))

(defn score [dice category]
  (cond (= category "yacht") (yacht-score dice)
	(= category "ones") (numeric-score dice 1)
	(= category "twos") (numeric-score dice 2)
	(= category "threes") (numeric-score dice 3)
	(= category "fours") (numeric-score dice 4)
	(= category "fives") (numeric-score dice 5)
	(= category "sixes") (numeric-score dice 6)
	(= category "full house") (full-house-score dice)
	(= category "four of a kind") (four-of-a-kind-score dice)
	(= category "little straight") (little-straight-score dice)
	(= category "big straight") (big-straight-score dice)
	(= category "choice") (choice-score dice)
	:else 0)
  )
