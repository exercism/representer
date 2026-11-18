(ns two-fer) (require '[clojure.string :as str]) (defn two-fer ([] (two-fer "")) ([name] (let [done (if (str/blank? name) "you" name)] (str "One for " done ", one for me."))))
