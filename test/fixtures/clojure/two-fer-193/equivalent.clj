(ns two-fer) (defn two-fer [& [name]] (if (= name nil) "One for you, one for me." (str "One for " name ", one for me.")) )
