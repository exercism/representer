module Rosetta::Languages::PHP::Representation
  class Spec < Rosetta::Engine::Representation
    version 9

    # Rename names, and variables with their `$`. PHP keeps variables apart
    # from functions, so `$count` and `count()` are different names.
    names_are :name,          # «count»
              :variable_name  # «$count»

    # Rename the names of classes, interfaces, traits and enums.
    names_are_defined_by class_declaration: :name,      # class «Counter» { ... }
                         interface_declaration: :name,  # interface «Shape» { ... }
                         trait_declaration: :name,      # trait «Greets» { ... }
                         enum_declaration: :name        # enum «Suit» { ... }

    # Rename the names of functions, methods, constants, enum cases and properties.
    names_are_defined_by function_definition: :name,  # function «area»($width) { ... }
                         method_declaration: :name,   # public function «area»() { ... }
                         const_element: :name,        # const «LIMIT» = 10;
                         enum_case: :name,            # case «Hearts»;
                         property_element: :name      # private $«count» = 0;

    # Rename parameters.
    names_are_defined_by simple_parameter: :name,             # function area(«$width»)
                         variadic_parameter: :name,           # function sum(...«$numbers»)
                         property_promotion_parameter: :name  # public function __construct(private «$name»)

    # Rename the variables on the left of an assignment.
    names_are_defined_by :list_literal,                           # [«$first», «$second»] = $pair;
                         assignment_expression: :left,            # «$total» = $price * 2;
                         augmented_assignment_expression: :left,  # «$total» += 1;
                         reference_assignment_expression: :left   # «$alias» = &$total;

    # Rename the variables of loops, `catch`, `global`, `static` and closures.
    names_are_defined_by :pair,                                # foreach ($xs as «$key» => «$value»)
                         :by_ref,                              # foreach ($xs as &«$x»)
                         :global_declaration,                  # global «$count»;
                         :anonymous_function_use_clause,       # function () use («$total») { ... }
                         foreach_statement: :value,            # foreach ($xs as «$x»)
                         catch_clause: :name,                  # catch (Exception «$error»)
                         static_variable_declaration: :name    # static «$count» = 0;

    # Rename the variables passed to a function, because a function can set a
    # variable passed by reference.
    names_are_defined_by :argument # preg_match('/a+/', $text, «$matches»)

    # Drop these imports, because a solution that passes its tests has already
    # loaded everything it needs.
    imports "use {{...}};",           # «use App\Helpers;»
            "require {{...}};",       # «require 'Helpers.php';»
            "require_once {{...}};",  # «require_once 'Helpers.php';»
            "include {{...}};",       # «include 'Helpers.php';»
            "include_once {{...}};"   # «include_once 'Helpers.php';»

    # Read a code pattern as code after the opening tag.
    pattern_contexts "<?php {{pattern}}" # «require 'x.php';»
  end
end
