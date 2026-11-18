(ns two-fer) (defn two-fer [& args] (def friend (first args)) (if (not= friend nil)(format "One for %s, one for me." friend) "One for you, one for me." ) )
