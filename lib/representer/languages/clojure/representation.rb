module Representer::Languages::Clojure
  class Representation < Representer::Engine::Representation
    version 10

    # Rename symbols.
    names_are :sym # «count»

    # Rename the names that a form defines. Every form is a list, so
    # Normalise marks each of these names as a definition or a local.
    names_are_defined_by :definition,  # (defn «area» [width] ...)
                         :local        # (let [«total» (* price 2)] ...)

    # Drop these imports, because a solution that passes its tests has
    # already made every namespace it needs available.
    imports "(:require {{...}})",  # (ns app «(:require [clojure.string :as str])»)
            "[:require {{...}}]",  # (ns app «[:require [clojure.string :as str]]»)
            "(:use {{...}})",      # (ns app «(:use clojure.set)»)
            "[:use {{...}}]",      # (ns app «[:use clojure.set]»)
            "(:import {{...}})",   # (ns app «(:import java.util.Date)»)
            "[:import {{...}}]",   # (ns app «[:import java.util.Date]»)
            "(require {{...}})",   # «(require '[clojure.string :as str])»
            "(use {{...}})",       # «(use 'clojure.set)»
            "(import {{...}})"     # «(import java.util.Date)»
  end
end
