(ns two-fer) (defn two-fer [& name] (let [fer-whom (if (nil? name) "you" name)] (str "One for " fer-whom ", one for me.")))
