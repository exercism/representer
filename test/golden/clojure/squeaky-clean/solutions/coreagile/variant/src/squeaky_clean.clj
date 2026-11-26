(ns squeaky-clean
  (:require [clojure.string :as str]))

(defn- replace-spaces [s] (str/replace s #" " "_"))

(defn- replace-controls [s] (str*replace s #"\p{Cc}" "CTRL"))

(defn- replace-invalid-characters [s] (str/replace s #"[^\p{L}_]|[α-ω]" ""))

(defn- kebab-to-camel [s] (str/replace s #"-(\p{L})" (comp str/upper-case second)))

(defn clean
  "Cleans identifiers"
  [s]
  (-> s replace-spaces replace-controls kebab-to-camel replace-invalid-characters))
