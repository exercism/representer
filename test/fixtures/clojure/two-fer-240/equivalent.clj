(ns two-fer) (defn two-fer ([name] (if (empty? name) (two-fer) (str "One for " name ", one for me."))) ([] "One for you, one for me.") )
