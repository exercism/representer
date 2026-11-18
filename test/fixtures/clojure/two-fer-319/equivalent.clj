(ns two-fer (:require [clojure.string :as string])) (defn two-fer ([] (str "One for you, one for me.")) ([name] (string/join "" ["One for " name ", one for me."])))
