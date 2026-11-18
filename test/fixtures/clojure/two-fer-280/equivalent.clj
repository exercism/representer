(ns two-fer) (require '[clojure.string :as string]) (defn two-fer ([name] (string/join ["One for " name ", one for me."])) ([] "One for you, one for me."))
