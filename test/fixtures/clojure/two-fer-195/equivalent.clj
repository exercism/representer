(ns two-fer) (defn two-fer [& all] (if (empty? all) "One for you, one for me." (str "One for " (apply str all) ", one for me.")) )
