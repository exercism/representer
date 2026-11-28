module Rosetta::Languages::Powershell::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename variables without their `$`, and splatted variables without
    # their `@`, so `$count`, `@count` and `.count` share one name.
    names_are :variable, without_prefix: "$"         # «$count»
    names_are :splat_expression, without_prefix: "@" # «@options»

    # Rename a command's parameter without its `-`, so `-Year` and `$year`
    # share one name.
    names_are :command_parameter_name, without_prefix: "-" # Test-Leap «-Year» 2000

    # Rename functions and the commands that call them, and the names of
    # classes, enums, members and types.
    names_are :function_name,  # function «Get-Total» { }
              :command_name,   # «Get-Total» 1 2
              :identifier,     # $this.«count»
              :type_identifier # [«Shape»]::new()

    # Rename functions, their parameters, and the variables assigned to.
    names_are_defined_by function_definition: :name,  # function «Get-Total» { }
                         parameter: :name,            # param([int]«$year»)
                         assignment_statement: :left, # «$count» = 0
                         foreach_statement: :variable # foreach («$item» in $items) { }

    # Rename classes and enums, and their properties, methods and members.
    names_are_defined_by class_definition: :name, # class «Shape» { }
                         class_property: :name,   # [int]«$Sides»
                         class_method: :name,     # [int] «Area»() { }
                         enum_definition: :name,  # enum «Color» { }
                         enum_member: :name       # enum Color { «Red» }

    # Drop the `using` statements, because a solution that passes its tests
    # has already made every namespace and module it needs available.
    imports "using namespace {{_}}", # «using namespace System.Text»
            "using module {{_}}",    # «using module ./Helpers.psm1»
            "using assembly {{_}}"   # «using assembly System.Drawing»
  end
end
