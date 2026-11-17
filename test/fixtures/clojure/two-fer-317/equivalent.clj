(ns two-fer) (defn two-fer ( [name] ( if (not= (empty? name) true) (str "One for " name ", one for me.") (str "One for you, one for me.") ) ) ( [] (str "One for you, one for me.") ) )
