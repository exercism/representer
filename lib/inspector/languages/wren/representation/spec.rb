module Inspector::Languages::Wren::Representation
  class Spec < Inspector::Engine::Representation
    version 9

    # Rename identifiers and fields.
    names_are :identifier,    # «count»
              :field,         # «_count»
              :static_field   # «__count»

    # Rename the names of classes and methods.
    names_are_defined_by class_definition: :name,        # class «Counter» { ... }
                         constructor_definition: :name,  # construct «new»(start) { ... }
                         getter_definition: :name,       # «count» { _count }
                         named_method: :name,            # «add»(n) { ... }
                         setter_definition: :name        # «count»=(value) { ... }

    # Rename variables and parameters, and the fields set in methods.
    names_are_defined_by :parameter_list,                 # add(«a», «b») { ... }
                         :closure_parameter_list,         # Fn.new {|«x»| x * 2 }
                         :subscript_parameter_list,       # [«index»] { ... }
                         var_statement: :name,            # var «total» = price * 2
                         assignment_expression: :target,  # «_count» = 0
                         operator_method: :parameter,     # +(«other») { ... }
                         for_statement: :variable         # for («item» in items) { ... }

    # Drop these imports, because a solution that passes its tests has already
    # imported every module it needs.
    imports 'import "{{_}}" for {{...}}', # «import "random" for Random»
            'import "{{_}}"'              # «import "random"»
  end
end
