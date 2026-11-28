module Rosetta::Languages::YAMLScript::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename the names of functions, parameters and variables.
    names_are :identifier # «count»

    # Rename the names of functions, their parameters, the variables that
    # assignments and bindings define, and the names that a vector takes
    # apart.
    names_are_defined_by :parameters,                # defn f(«a» «b»): ...
                         :vector_pattern,            # [«a» «b»] =: pair
                         :rest_parameter,            # defn f(*«rest»): ...
                         function_definition: :name, # defn «area»(w): ...
                         assignment: :left,          # «total» =: 0
                         bindings: :name             # loop «i» 0: ...

    # Drop the libraries a solution loads, because a solution that passes
    # its tests has already loaded everything it needs.
    imports "use: {{...}}" # «use: clojure.string»
  end
end
