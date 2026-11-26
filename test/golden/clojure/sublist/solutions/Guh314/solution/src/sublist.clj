(ns sublist)

(defn sublist?
  "Check if a list is a sublist of another."
  [a b]
  (some #{a} (partition (count a) 1 b)))


(defn classify
  "Classify the relation betwee two list in :sublist, :superlist, :equal or :unequal"
  [list1 list2]
  (cond
    (= list1 list2) :equal
    (sublist? list1 list2) :sublist
    (sublist? list2 list1) :superlist
    :else :unequal))