module Representer::Languages::Scala
  class Representation < Representer::Engine::Representation
    version 6

    # Rename identifiers, operators and the names of types.
    names_are :identifier,          # «count»
              :operator_identifier, # a «|+|» b
              :type_identifier      # List[«Counter»]

    # Rename the names of objects, classes, traits, enums, types and type
    # parameters.
    names_are_defined_by object_definition: :name,            # object «Leap»
                         class_definition: :name,             # case class «Point»(x: Int)
                         trait_definition: :name,             # trait «Shape»
                         enum_definition: :name,              # enum «Color»
                         simple_enum_case: :name,             # case «Red», «Green»
                         full_enum_case: :name,               # case «Rgb»(r: Int)
                         type_definition: :name,              # type «Grid» = List[List[Int]]
                         type_parameters: :name,              # def first[«T»](xs: List[T])
                         covariant_type_parameter: :name,     # trait Box[+«T»]
                         contravariant_type_parameter: :name  # trait Sink[-«T»]

    # Rename the names of methods and givens.
    names_are_defined_by function_definition: :name,  # def «area»(width: Int) = ...
                         function_declaration: :name, # def «area»: Double
                         given_definition: :name      # given «order»: Ordering[Int] = ...

    # Rename values, variables and parameters.
    names_are_defined_by :identifiers,                  # val «a», «b» = 0
                         val_definition: :pattern,      # val «count» = 0
                         var_definition: :pattern,      # var «count» = 0
                         val_declaration: :name,        # val «size»: Int
                         var_declaration: :name,        # var «size»: Int
                         parameter: :name,              # def area(«width»: Int)
                         class_parameter: :name,        # case class Point(«x»: Int)
                         binding: :name,                # («acc», «x») => acc + x
                         lambda_expression: :parameters # «x» => x * 2

    # Rename the variables bound by patterns.
    names_are_defined_by :bind,                  # case Some(«x») =>, for («x» <- xs)
                         capture_pattern: :name  # case «all» @ List(_, _) =>

    # Drop these imports, because a solution that passes its tests has already
    # imported everything it needs.
    imports "import {{...}}" # «import scala.math.abs»
  end
end
