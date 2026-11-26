(ns sublist)




; does not handle case of repeated numbers.
;
(defn verify-sublist
  "verifies that list 1 is a sublist of list2. list1 must have fewer
  elements than list 2. this does not handle the case of repeated numbers.
   "
  ([list1 list2]

    (println "-- verify sublist --")
    (def index (.indexOf list2 (first list1)) )
    (println (str "index: " index))

    (if (= index -1)
      0
      (verify-sublist list1 (drop index list2) (first list1) 0)
    )
  )
  ([list1 list2 item counter]

   (println "-- verify sublist2 --")
    (println (str "item: " item) )
    (println (str "is item nil ?: " (nil? item)) )

    (println (str "count: " counter))
    (println (str "list 1: " list1))
    (println (str "list 2: " list2))
    (if (empty? list1)
      (do (println "exiting now.") (identity counter))
      (if
          (= (.indexOf list2 item) 0)
        (do (def accum (+ counter 1))
            (verify-sublist (rest list1) (drop 1 list2) (first (rest list1) ) accum ) )
        (identity counter)
        )
      )

   )

   )


; no longer in use. since veirfy sublist does not pass all test cases
(defn is-sublist
  "is list1 a sublist of list2 returns true or false"
  [list1 list2]
  (if (= (verify-sublist list1 list2) (count list1) )
    true
    false
   )

  )


; this passes all test cases
(defn verify-sublist2
  "verifies that list1 is a sub list of list2. this approach uses
  take and drop functions."
  ( [list1 list2]
   (def n (count list1) )

   (def sublist2 (take n list2))

   (if (= list1 sublist2 )
     true
     (verify-sublist2 list1 (drop 1 list2) n (- (count list2) 1) )
	 )


  )
     (
      [list1 list2 list1_size list2_size]
      (def n (count list1) )
      (def sublist2 (take n list2))

      (if (<= list1_size list2_size)
        (if (= list1 sublist2)
          true
          (verify-sublist2 list1 (drop 1 list2) n (- (count list2) 1) )
          )
           false
       )


      )

)




(defn classify [list1 list2] ;; <- arglist goes here
  ;; your code goes here
  (def sublist :sublist)
  (def superlist :superlist)
   (def equal :equal)
  (def unequal :unequal)
  (def list1_size (count list1))
  (def list2_size (count list2))

  (cond
   (= list1_size list2_size) (if (= list1 list2) equal unequal )
  ; (< list1_size list2_size) (if (is-sublist list1 list2) sublist unequal )
  ; (> list1_size list2_size) (if (is-sublist list2 list1) superlist unequal )
   (< list1_size list2_size) (if (verify-sublist2 list1 list2) sublist unequal )
   (> list1_size list2_size) (if (verify-sublist2 list2 list1) superlist unequal )


    )


  )
