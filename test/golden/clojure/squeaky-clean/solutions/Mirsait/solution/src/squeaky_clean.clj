(ns squeaky-clean
  (:require [clojure.string :as str]))

;; nice solution
;; https://exercism.org/tracks/clojure/exercises/squeaky-clean/solutions/kushalk14

(defn clean
  "Clean up identifier names"
  [s]
  (-> s
      (str/replace #"\s" "_")
      (str/replace #"\p{Cc}" "CTRL")
      (str/replace #"-(\p{L})" #(str/upper-case (%1 1)))
      (str/replace #"[^\p{L}_]|[α-ω]" "")))
