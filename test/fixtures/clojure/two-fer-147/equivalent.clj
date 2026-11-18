(ns two-fer) (defn two-fer ([] (str "One for you, one for me.")) ([name] (#(str "One for " % ", one for me.")name)) )
