(ns two-fer) (defn two-fer [& name] ( let [this-name (cond (nil? name) "you" :else (first name))] (str "One for " this-name ", one for me.") ) )
