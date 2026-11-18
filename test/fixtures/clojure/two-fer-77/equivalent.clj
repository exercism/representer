(ns two-fer (:require [clojure.string :as str])) (defn two-fer ([name] (let [n (if (str/blank? name) "you" name)] (format "One for %s, one for me." n) )) ([] "One for you, one for me." ) )
