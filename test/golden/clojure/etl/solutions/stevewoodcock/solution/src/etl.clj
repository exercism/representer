(ns etl
  (:require [clojure.string :as str]))

(defn transform [by-score]
  (into {} (for [[score words] by-score
                 word words]
             [(str/lower-case word) score])))