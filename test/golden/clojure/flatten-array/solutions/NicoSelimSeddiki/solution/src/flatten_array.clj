(ns flatten-array
  (:require [clojure.core :as core]))

(defn flatten [arr] ;; <- arglist goes here
  (filterv (fn [x] (not= x nil)) (core/flatten arr))
)
