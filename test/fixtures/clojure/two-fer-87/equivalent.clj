(ns two-fer) (use 'clojure.string) (defn two-fer [& [name]] (format "One for %s, one for me." (or name "you")) )
