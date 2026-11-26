(ns log-levels
  (:require [clojure.string :as str]))

(def pattern #"\[([A-Z]+)\]\:\s*(.+)\s*")
(def tempate "%s (%s)")

(defn message
  "Takes a string representing a log line
   and returns its message with whitespace trimmed."
  [s]
  (str/trim
   (first
    (next
     (next
      (re-matches pattern s))))))

(defn log-level
  "Takes a string representing a log line
   and returns its level in lower-case."
  [s]
  (str/lower-case (second (re-matches pattern s))))

(defn reformat
  "Takes a string representing a log line and formats it
   with the message first and the log level in parentheses."
  [s]
  (format tempate (message s) (log-level s)))
