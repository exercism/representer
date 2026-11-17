(ns two-fer (:require [clojure.string :as str]) ) (defn two-fer [name] (if (nil? name) (str "One for you, one for me.") (str "One for " name ", one for me.")) )
