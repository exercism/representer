(ns two-fer (:require [clojure.string :as str])) (defn two-fer ([] "One for you, one for me.") ([name] (let [res (cond (str/blank? name) "you" :else name)] (str "One for " res ", one for me."))) )
