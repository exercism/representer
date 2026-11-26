(ns sublist)

(defn front [v] (pop v))

(defn back [v]
  (if
    (= (count v) 1) [] (subvec v 1)))

(defn isSublist [list1 list2]
  (cond
    (= list1 list2) true
    (empty? list2) false
    :else (or
      (isSublist list1 (front list2))
      (isSublist list1 (back list2)))))

(defn classify [list1 list2]
  (cond
    (= list1 list2) :equal
    (isSublist list1 list2) :sublist
    (isSublist list2 list1) :superlist
    :else :unequal))