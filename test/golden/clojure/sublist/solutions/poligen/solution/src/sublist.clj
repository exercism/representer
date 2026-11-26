;;  "List1  is sublist of List2 only when:
;; List1 isn't longer than List2 [and]
;; List1 is a beggining of List2 [or] any rest of List2"
;;    (and (<= len (count r))
         ;; (or (= l (take len r))
         ;;     (recur l (rest r) len)))


(ns sublist)
(defn sublist? [list1 list2]
    (cond
      (= (count list2) 0) false
      (= list1 (take (count list1) list2)) true
      :else (recur list1 (rest list2))
          )
  )


(defn classify [list1 list2]
    (cond
      (= list1 list2) :equal
      (sublist? list1 list2) :sublist
      (sublist? list2 list1) :superlist
      :else  :unequal
      )
    )
