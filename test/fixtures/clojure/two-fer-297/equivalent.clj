(ns two-fer) (defn two-fer ([] "One for you, one for me.") ([name] (if (= name "") "One for you, one for me." (str "One for " name ", one for me."))) )
