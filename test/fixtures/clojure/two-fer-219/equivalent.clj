(ns two-fer) (defn two-fer [& [name]] (let [person (if (= (count name) 0) "you" name)] (str "One for " person ", one for me.")) )
