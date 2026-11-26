(ns log-levels
  (:require [clojure.string :as str]))

(def ^:private log-matcher #"(]: )|(\[)")

(defn parse-log [s]
  (let [parsed-log (->> log-matcher
                        (str/split s)
                        (remove str/blank?)
                        (map str/trim)
                        (zipmap [:log-level :message]))]
    (update parsed-log :log-level str/lower-case)))

(defn message [s]
  (:message (parse-log s)))

(defn log-level [s]
  (:log-level (parse-log s)))

(defn reformat [s]
  (let [{msg :message, lvl :log-level} (parse-log s)] 
    (format "%s (%s)" msg lvl)))
  
