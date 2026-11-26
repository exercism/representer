(ns log-levels
  (:require [clojure.string :as str]))
(use 'clojure.string)

(defn message
  "Takes a string representing a log line
   and returns its message with whitespace trimmed."
  [s]
  (trim s)
  (trim (last (str/split s #": ")))
  )

(defn log-level
  "Takes a string representing a log line
   and returns its level in lower-case."
  [s]
  (str/replace (lower-case (trim (first (str/split s #": ")))) #"\[|\]" "")
  )

(defn reformat
  "Takes a string representing a log line and formats it
   with the message first and the log level in parentheses."
  [s]
  (str (message s) " (" (log-level s) ")")
  )
