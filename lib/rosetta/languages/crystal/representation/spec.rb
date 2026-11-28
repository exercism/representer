module Rosetta::Languages::Crystal::Representation
  class Spec < Rosetta::Engine::Representation
    version 11

    # Rename identifiers and constants.
    names_are :identifier,  # «count»
              :constant     # «Counter»

    # Rename instance and class variables as the name without the `@`, so
    # `@count` gets the same placeholder as the `count` of `getter count`.
    names_are :instance_var, without_prefix: "@" # @«count»
    names_are :class_var, without_prefix: "@@"   # @@«count»

    # Rename the names of types and their type variables.
    names_are_defined_by :generic_type,      # class «Box»(T) ... end
                         :type_vars,         # class Box(«T») ... end
                         :type_name,         # module «Shop»::«Counting» ... end
                         class_def: :name,   # class «Counter» ... end
                         module_def: :name,  # module «Counting» ... end
                         struct_def: :name,  # struct «Point» ... end
                         enum_def: :name,    # enum «Color» ... end
                         alias: :name        # alias «Count» = Int32

    # Rename constants and the members of enums.
    names_are_defined_by :enum_body,         # enum Color «Red»; «Green» = 2 end
                         const_assign: :lhs  # «LIMIT» = 10

    # Rename the names of methods and macros.
    names_are_defined_by method_def: :name,           # def «area»(width) ... end
                         abstract_method_def: :name,  # abstract def «area»
                         macro_def: :name             # macro «define»(name) ... end

    # Rename the parameters of methods, blocks and procs.
    names_are_defined_by :forall,                    # def first(xs : Array(T)) forall «T»
                         param: :name,               # def area(«width», «height»)
                         splat_param: :name,         # def sum(*«numbers»)
                         double_splat_param: :name,  # def build(**«options»)
                         block_param: :name          # def each(&«block»)

    # Rename the names on the left of an assignment or a declaration, and
    # the variable of `rescue`.
    names_are_defined_by :targets,                # «first», «second» = pair
                         assign: :lhs,            # «total» = price * 2
                         op_assign: :lhs,         # «total» += 1
                         type_declaration: :var,  # «total» : Int32 = 0
                         rescue: :variable        # rescue «error» : ArgumentError

    # Drop these imports, because a solution that passes its tests has already
    # loaded everything it needs.
    imports 'require "{{_}}"' # «require "big"»
  end
end
