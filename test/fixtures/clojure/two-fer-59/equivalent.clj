(ns two-fer) (defn two-fer ([name](format "One for %s, one for me." (cond (> 0 (count name)) "you" :else name))) ([] "One for you, one for me.") )
