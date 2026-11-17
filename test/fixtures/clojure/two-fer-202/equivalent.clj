(ns two-fer) (defn two-fer ([] (two-fer "you")) ([name] (format "One for %s, one for me." (if (nil? name) "you" name)))) (comment (two-fer nil) (two-fer "Lupo") )
