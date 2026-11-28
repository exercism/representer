module Representer::Languages::Raku::Representation
  class Spec < Representer::Engine::Representation
    version 9

    # Rename names, and variables with their sigil. A variable's sigil is
    # part of its name, so `$count` and a sub called `count` stay apart.
    names_are :identifier,  # sub «count»
              :scalar,      # «$count»
              :array,       # «@items»
              :hash,        # «%totals»
              :code         # «&square»

    # Rename a sigilless variable as the name it is used by, without its `\`.
    names_are :sigilless_variable, without_prefix: "\\" # my \«total» = 1

    # Rename the names of subs, methods, classes, modules and constants.
    names_are_defined_by routine_declaration: :name,  # sub «area»($width) { ... }
                         package_declaration: :name,  # class «Counter» { ... }
                         unit_declaration: :name,     # unit module «Leap»;
                         constant_declaration: :name  # constant «LIMIT» = 10;

    # Rename variables and parameters. A public attribute (`$.size`) and a
    # named parameter (`:$size`) keep their names, because callers use them.
    names_are_defined_by :variable_declaration,  # my («$first», «@rest»), has «$!count»
                         parameter: :name        # sub area(«$width», «\height»)

    # Drop these imports of modules, because a solution that passes its tests
    # has already loaded everything it needs.
    imports "use {{Module}}",      # «use JSON::Fast;»
            "need {{Module}}",     # «need Foo;»
            "require {{Module}}",  # «require Foo;»
            "import {{Module}}"    # «import Foo;»
  end
end
