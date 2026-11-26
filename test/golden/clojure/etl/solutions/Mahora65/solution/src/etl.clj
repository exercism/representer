(ns etl
  (:require [clojure.string :as str]))

(defn transform [source] ;; <- arglist goes here
  (into {}
        (for [[score letters] source letter letters]
          [(str/lower-case letter) score]))
)
