(ns two-fer) (defn two-fer [&[name]] (str "One for " (if name (str name ", one for me.") "you, one for me.") ) )
