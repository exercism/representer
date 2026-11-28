module Inspector::Languages::Swift::Representation
  class Spec < Inspector::Engine::Representation
    version 6

    # Rename identifiers and the names of types.
    names_are :simple_identifier,  # «count»
              :type_identifier     # «Counter»

    # Rename the names of types and their parameters.
    names_are_defined_by :type_parameter,                       # func f<«T»>(_ a: T)
                         class_declaration: :name,              # struct «Point» { ... }
                         protocol_declaration: :name,           # protocol «Shape» { ... }
                         typealias_declaration: :name,          # typealias «Grid» = [[Int]]
                         associatedtype_declaration: :name      # protocol Stack { associatedtype «Item» }

    # Rename the names of functions, enum cases and labels.
    names_are_defined_by :enum_type_parameters,                 # case circle(«radius»: Double)
                         :tuple_type_item,                      # let p: («name»: String, «score»: Int)
                         function_declaration: :name,           # func «area»() -> Int { ... }
                         protocol_function_declaration: :name,  # protocol Shape { func «area»() -> Int }
                         enum_entry: :name,                     # case «red», «green»
                         tuple_expression: :name                # let p = («name»: "a", «score»: 1)

    # Rename parameters, their labels, and the variables that patterns and
    # conditions bind.
    names_are_defined_by :parameter,                            # func f(«by» «step»: Int)
                         :computed_setter,                      # set(«value») { ... }
                         :statement_label,                      # «outer»: for x in xs { ... }
                         lambda_parameter: :name,               # { «x» in x + 1 }
                         capture_list_item: :name,              # { [«total» = sum] in total }
                         pattern: :bound_identifier,            # let «total» = 0
                         if_statement: :bound_identifier,       # if let «value» = x { ... }
                         guard_statement: :bound_identifier,    # guard let «value» = x else { ... }
                         while_statement: :bound_identifier     # while let «line» = readLine() { ... }

    # Drop these imports, because a solution that passes its tests has already
    # made every name it needs available.
    imports "import {{...}}" # «import Foundation»
  end
end
