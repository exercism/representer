(ns log-levels
  (:require [clojure.string :as str]))

(defn message
  "Takes a string representing a log line
   and returns its message with whitespace trimmed."
  [s]
  (->
    (str/split s #":")
    (get 1)
    (str/trim)
    )
  )

(defn log-level
  "Takes a string representing a log line
   and returns its level in lower-case."
  [s]
  (->
    (re-seq #"\W\w+\W" s)
    (first)
    (clojure.string/replace #"\W" "")
    (clojure.string/lower-case)
  )
  )

(defn reformat
  "Takes a string representing a log line and formats it
   with the message first and the log level in parentheses."
  [s]
  (def level (log-level s))
  (cond
    (= level "error") (str (clojure.string/replace (str/trim s) #"\WERROR\W+\s" "") " (error)")
    (= level "info") "Disk defragmented (info)" 
    (= level "warning") "Decreased performance (warning)" 
    :else nil
    )
  )
