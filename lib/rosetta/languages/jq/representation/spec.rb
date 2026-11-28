module Rosetta::Languages::Jq::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename the names of functions and variables. A variable keeps its `$`,
    # so it stays apart from a function with the same name.
    names_are :identifier, # «colors»
              :variable    # «$color»

    # Rename the names of functions and their parameters.
    names_are_defined_by :parameter_list,           # def f(«$a»; «g»): ...;
                         function_definition: :name # def «f»: ...;

    # Rename the variables bound by `as` and in its patterns, and the names
    # of labels.
    names_are_defined_by :array_pattern,                # . as [«$a», «$b»]
                         binding_expression: :bindings, # . as «$x»
                         pair_pattern: :value,          # . as {"a": «$x»}
                         label_expression: :name        # label «$out»

    # Drop these imports, because a solution that passes its tests has
    # already loaded every module it needs.
    imports 'import "{{_}}" as {{...}};', # «import "lib" as lib;»
            'include "{{_}}";'            # «include "lib";»
  end
end
