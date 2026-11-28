module Inspector::Languages::Kotlin::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename identifiers, the names of types and labels.
    names_are :simple_identifier,  # «count»
              :type_identifier,    # «Counter»
              :label               # break@«outer»

    # Rename the names of classes, interfaces, objects, type aliases and type
    # parameters.
    names_are_defined_by :class_declaration,  # class «Counter», interface «Shape», enum class «Color»
                         :object_declaration, # object «Leap»
                         :companion_object,   # companion object «Factory»
                         :type_alias,         # typealias «Grid» = List<List<Int>>
                         :type_parameter      # fun <«T»> first(items: List<T>)

    # Rename the names of functions and enum entries.
    names_are_defined_by :function_declaration, # fun «area»(width: Int)
                         :enum_entry            # enum class Color { «RED», «GREEN» }

    # Rename properties, local variables, parameters and the variables of
    # `catch` blocks.
    names_are_defined_by :variable_declaration,         # val «count» = 0, for («item» in items), { «x» -> x }
                         :class_parameter,              # class Point(val «x»: Int)
                         :parameter,                    # fun area(«width»: Int)
                         :parameter_with_optional_type, # set(«value») { field = value }
                         :catch_block                   # catch («error»: Exception)

    # Rename labels.
    names_are_defined_by labeled_expression: :label # «outer»@ for (x in xs)

    # Drop these imports, because a solution that passes its tests has already
    # imported everything it needs.
    imports "import {{...}}" # «import kotlin.math.abs»
  end
end
