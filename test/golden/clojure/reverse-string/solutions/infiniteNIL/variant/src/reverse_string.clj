(ns reverse-string)

(defn reverse-string 
  ([s]
   (reverse-string s ""))
  ([s reversed]
   (if (empty? s)
       reversed
       (let [ch (str (last s))
             last-ndx (dec (count s))]
         (recur (subs s 1 last-ndx) 
                (str reversed ch))))))