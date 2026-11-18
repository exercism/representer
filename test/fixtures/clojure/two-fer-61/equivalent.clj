(ns two-fer) (defn two-fer [& names] (if (nil? names) (str "One for you, one for me.") (str "One for " (first names) ", one for me.")))
