(ns two-fer) (defn two-fer [& [name]] (if name (format "One for %s, one for me." name) (format "One for you, one for me.")))
