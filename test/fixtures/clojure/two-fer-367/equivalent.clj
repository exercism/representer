(ns two-fer) (defn two-fer [& [friend]] (str "One for " (or friend "you") ", one for me.") )
