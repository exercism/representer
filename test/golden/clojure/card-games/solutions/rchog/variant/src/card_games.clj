(ns card-games)
(declare re-rounds)
(defn rounds
  "Takes the current round number and returns 
   a `list` with that round and the _next two_."
  [n]
  (re-rounds 2 n))
(defn re-rounds
  [i n]
  (if (= i 0)
    (cons (+ n (- 2 i)) ())
    (cons (+ n (- 2 i)) (re-rounds (- i 1) n))))

(defn concat-rounds 
  "Takes two lists and returns a single `list` 
   consisting of all the rounds in the first `list`, 
   followed by all the rounds in the second `list`"
  [l1 l2]
  (concat l1 l2))

(defn contains-round? 
  "Takes a list of rounds played and a round number.
   Returns `true` if the round is in the list, `false` if not."
  [l n]
  (cond 
    (= 0 (count l)) false
    :else (if (= (first l) n)
            true
            (contains-round? (rest l) n))))

(defn card-average
  "Returns the average value of a hand"
  [hand]
  (float (/ (reduce + hand) (count hand))))

(defn approx-average?
  "Returns `true` if average is equal to either one of:
  - Take the average of the _first_ and _last_ number in the hand.
  - Using the median (middle card) of the hand."
  [hand]
  (if (== (/ (+ (first hand) (last hand)) 2) (card-average hand))
    true
    (if (== (nth hand (/ (count hand) 2)) (card-average hand))
      true
      false)))

(declare sum-evens)
(declare sum-odds)
(defn average-even-odd? 
  "Returns true if the average of the cards at even indexes 
   is the same as the average of the cards at odd indexes."
  [hand]
  (if (= (/ (sum-evens hand) (Math/ceil (/ (count hand) 2))) 
         (/ (sum-odds hand) (Math/floor (/ (count hand) 2))))
    true
    false))
(defn sum-evens
  [hand]
  (if (> (count hand) 2)
    (+ (first hand) (sum-evens (rest (rest hand))))
    (first hand)))
(defn sum-odds
  [hand]
  (sum-evens (rest hand)))

(defn maybe-double-last
  "If the last card is a Jack (11), doubles its value
   before returning the hand."
  [hand]
  (if (not= (last hand) 11)
    (concat (drop-last hand) (cons (* (last hand) 2) '()))
    hand))
