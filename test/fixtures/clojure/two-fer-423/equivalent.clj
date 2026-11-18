(ns two-fer) (defn two-fer [& name] (cond (= name nil) "One for you, one for me." :else (str "One for "(apply str name) ", one for me.") ) )
