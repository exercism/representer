(ns yacht)
(defn- score-yacht 
  "Score a set of five dice as a 'Yacht', or five of a kind.
  Worth 50 points if all five dice are the same, no matter their
  individual values. Worth 0 if all five dice are not the same."
  ([dice]
   (score-yacht (first dice) dice))
  ([value [die & rest]]
    (cond 
      (nil? die) 50
      (= value die) (score-yacht value rest)
      :else 0)))
(defn- score-number
  "There are six 'number' categories, one for each possible dice value.
  When scoring this category, sum the value of all dice with the named
  value. For example, (score-number 2 [2 3 2 4 5]) yields 4."
  ([number dice]
   (score-number number dice 0))
  ([number [die & rest] total]
   (cond 
     (nil? die) total
     (= number die) (score-number number rest (+ total number))
     :else (score-number number rest total))))
(defn- map-dice
  "Produce an array-map of dice values to the number of dice in five
  that show that value."
  ([dice]
   (map-dice {1 0 2 0 3 0 4 0 5 0 6 0} dice))
  
  ([dice-map [die & rest]]
   (cond
     (nil? die) (into {} (filter (fn [[_ v]] (> v 0))) dice-map)
     (contains? dice-map die) (map-dice (update dice-map die inc) rest)
     :else nil)))
(defn- full-house?
  "Determine whether a throw of five dice is a 'Full House', indicated by
  having 3 dice of one value and 2 dice of another."
  [dice]
  (let [dice-map (map-dice dice)]
    ; Check for only two different dice values and a maximum of 
    ; 3 dice of any one value.
    (and (= 2 (count dice-map))
         (= 3 (apply max (vals dice-map))))))
(defn- score-full-house
  "A 'Full House' is worth the sum of the dice if it has three dice of
  one value and two dice of another. Otherwise, it is worth no points."
  [dice]
  (if (full-house? dice)
    (reduce + dice)
    0))
(defn- score-four-of-a-kind
  "A 'Four of a Kind' is worth the four times the value that appears four
  or more times. Worth no points if no value appears four or more times."
  [dice]
  (->> dice
       map-dice
       (map (fn [[k v]] (if (>= v 4) (* k 4) 0)))
       (apply max)))
(defn- little-straight?
  "A 'Little Straight' is the dice [1 2 3 4 5] in any order."
  [dice]
  (let [dice-map (map-dice dice)]
    (and (= 1 (get dice-map 1))
         (= 1 (get dice-map 2))
         (= 1 (get dice-map 3))
         (= 1 (get dice-map 4))
         (= 1 (get dice-map 5)))))
(defn- score-little-straight
  "A 'Little Straight' is worth 30 points if all dice values required are present,
  otherwise worth no points."
  [dice]
  (if (little-straight? dice) 30 0))
(defn- big-straight?
  "A 'Big Straight' is the dice [2 3 4 5 6] in any order."
  [dice]
  (let [dice-map (map-dice dice)]
    (and (= 1 (get dice-map 2))
         (= 1 (get dice-map 3))
         (= 1 (get dice-map 4))
         (= 1 (get dice-map 5))
         (= 1 (get dice-map 6)))))
(defn- score-big-straight
  "A 'Big Straight' is worth 30 points if all dice values required are present,
  otherwise worth no points."
  [dice]
  (if (big-straight? dice) 30 0))
(defn score
  "Given five dice values and a category to score against, return the score of the
  throw given the rules of Yacht."
  [dice category]
  (case category 
    "yacht"           (score-yacht dice)
    "ones"            (score-number 1 dice)
    "twos"            (score-number 2 dice)
    "threes"          (score-number 3 dice)
    "fours"           (score-number 4 dice)
    "fives"           (score-number 5 dice)
    "sixes"           (score-number 6 dice)
    "full house"      (score-full-house dice)
    "four of a kind"  (score-four-of-a-kind dice)
    "little straight" (score-little-straight dice)
    "big straight"    (score-big-straight dice)
    "choice"          (reduce + dice)
    nil))
