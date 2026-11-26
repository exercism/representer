(ns etl (:require [clojure.string :as str]))

(defn transform [old-data-format]
  (into {}
        (for [[score letters] old-data-format letter letters]
          [(str/lower-case letter) score])))