(ns yacht)

(defmulti score-yacht (fn [_ c] c))

(defmethod score-yacht "yacht" [dice _] (when (apply = dice) 50))
(defmethod score-yacht "little straight" [dice _] (when (= dice [1 2 3 4 5]) 30))
(defmethod score-yacht "big straight" [dice _] (when (= dice [2 3 4 5 6]) 30))
(defmethod score-yacht "choice" [dice _] (apply + dice))
(defmethod score-yacht "full house" [[d1 d2 d3 d4 d5 :as dice] _]
  (cond
    (and (= d1 d2 d3) (= d4 d5) (not= d1 d5)) (apply + dice)
    (and (not= d1 d2) (= d3 d4 d5) (not= d1 d5)) (apply + dice)))

(defmethod score-yacht "four of a kind" [[d1 d2 d3 d4 d5 :as dice] _]
  (cond
    (and (= d1 d2 d3 d4)) (+ d1 d2 d3 d4)
    (and (= d2 d3 d4 d5)) (+ d2 d3 d4 d5)))

(defmethod score-yacht "ones" [dice _] (apply + (filter #{1} dice)))
(defmethod score-yacht "twos" [dice _] (apply + (filter #{2} dice)))
(defmethod score-yacht "threes" [dice _] (apply + (filter #{3} dice)))
(defmethod score-yacht "fours" [dice _] (apply + (filter #{4} dice)))
(defmethod score-yacht "fives" [dice _] (apply + (filter #{5} dice)))
(defmethod score-yacht "sixes" [dice _] (apply + (filter #{6} dice)))

(defmethod score-yacht :default [dice claim] [dice claim])

(defn score [dice claim]
  (or (score-yacht (sort dice) claim) 0))
