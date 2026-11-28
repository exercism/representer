module Inspector::Languages::Reasonml::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename values, operators, labels, record fields, constructors, types,
    # type variables and modules.
    names_are :value_identifier,    # «count»
              :operator,            # a «>>» b
              :label,               # f(~«width»=1)
              :field_identifier,    # p.«width»
              :constructor,         # «Circle»(1.0)
              :type_identifier,     # «shape»
              :type_variable_name,  # list(«'a»)
              :module_identifier    # «Counter».reset

    # Rename the names of values, functions and operators, their parameters
    # and labels, and the variables in patterns and loops.
    names_are_defined_by :value_pattern,             # let «area» = («width», «height») => ...
                         labeled_parameter: :label   # let area = (~«width») => ...

    # Rename the names of types, and of their constructors, fields and type
    # variables.
    names_are_defined_by :type_variable,                # let first = (xs: list(«'a»)) => ...
                         type_binding: :name,           # type «shape» = ...
                         variant_declaration: :name,    # type shape = «Circle»(float)
                         record_type_field: :name,      # type point = {«x»: int}
                         exception_declaration: :name   # exception «Invalid»(string)

    # Rename the names of modules, module types and functor parameters.
    names_are_defined_by module_declaration: :name,       # module «Counter» = { ... }
                         module_type_declaration: :name,  # module type «Shape» = { ... }
                         functor: :parameter              # module Make = («X»: S) => { ... }

    # Drop the opens, because a solution that passes its tests has already
    # opened every module it needs.
    imports "open {{...}}",  # «open Belt»
            "open! {{...}}"  # «open! Belt»
  end
end
