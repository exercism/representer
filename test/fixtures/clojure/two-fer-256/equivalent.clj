(ns two-fer) (defn two-fer [name] (if (not= name nil) (str "One for " name ", one for me.") "One for you, one for me.") )
