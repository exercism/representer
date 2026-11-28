module Representer::Languages::OCaml::Representation
  class Spec < Representer::Engine::Representation
    version 6

    # Rename values, labels, constructors, types, record fields, modules,
    # type variables, classes, methods and instance variables.
    names_are :value_name,              # «count»
              :label_name,              # ~«width»
              :constructor_name,        # «Circle»
              :type_constructor,        # «shape»
              :field_name,              # p.«width»
              :module_name,             # «Counter».reset
              :module_type_name,        # module type «Shape» = sig ... end
              :type_variable_name,      # «'a» list
              :class_name,              # new «counter»
              :method_name,             # c#«incr»
              :instance_variable_name   # «count» <- 0

    # Rename the operators the solution defines.
    names_are :prefix_operator,  # «!!» x
              :add_operator,     # a «+!» b
              :mult_operator,    # a «*!» b
              :pow_operator,     # a «**!» b
              :concat_operator,  # a «@!» b
              :rel_operator,     # a «|>!» b
              :and_operator,     # a «&&» b
              :or_operator,      # a «||» b
              :assign_operator,  # a «:=» b
              :hash_operator,    # a «##» b
              :let_operator      # «let*» x = y in ...

    # Rename the names of values and functions, their parameters and labels,
    # and the variables in patterns and loops.
    names_are_defined_by :value_pattern,              # let «area» «width» = ...
                         parameter: :name,            # let area ~«width» = ...
                         value_specification: :name,  # val «area» : int -> int
                         external: :name              # external «area» : int -> int = "area"

    # Rename the names of types, and of their constructors, fields and type
    # variables.
    names_are_defined_by :type_variable,                  # let first (xs : «'a» list) = ...
                         type_binding: :name,             # type «shape» = ...
                         constructor_declaration: :name,  # type shape = «Circle» of float
                         field_declaration: :name         # type point = { «x» : int }

    # Rename the names of modules, module types, classes, methods and
    # instance variables.
    names_are_defined_by module_binding: :name,               # module «Counter» = struct ... end
                         module_parameter: :name,             # module Make («X» : S) = ...
                         module_type_definition: :name,       # module type «S» = sig ... end
                         class_binding: :name,                # class «counter» = object ... end
                         method_definition: :name,            # method «incr» = ...
                         instance_variable_definition: :name  # val mutable «count» = 0

    # Drop the opens at the top of a module, because a solution that passes
    # its tests has already opened every module it needs.
    imports "open {{...}}", # «open Base»
            "open! {{...}}" # «open! Base»
  end
end
