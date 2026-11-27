module Representer::Languages::Nim
  class Representation < Representer::Engine::Representation
    version 9

    # Rename identifiers.
    names_are :identifier # «count»

    # Rename the names of types, and of routines such as procs and iterators.
    names_are_defined_by type_symbol_declaration: :name,  # type «Point» = object
                         proc_declaration: :name,         # proc «area»(width: int): int
                         func_declaration: :name,         # func «area»(width: int): int
                         method_declaration: :name,       # method «area»(shape: Shape): int
                         iterator_declaration: :name,     # iterator «pairs»(xs: Grid): int
                         template_declaration: :name,     # template «check»(x: bool)
                         macro_declaration: :name,        # macro «build»(body: untyped)
                         converter_declaration: :name     # converter «toInt»(x: Digit): int

    # Rename variables, parameters, fields, enum values and the variables of
    # `for`, and every name marked with `*` to export it.
    names_are_defined_by :exported_symbol,          # proc «area»*(width: int): int
                         symbol_declaration: :name  # let «total» = 1, proc f(«width»: int), for «i» in xs

    # Drop every import, because a solution that passes its tests has already
    # made every module it needs available. Drop exports too, because they
    # only make names available to the code that imports the solution.
    imports "import {{...}}",                # «import strutils»
            "import {{...}} except {{...}}", # «import strutils except toUpper»
            "from {{...}} import {{...}}",   # «from math import sqrt»
            "include {{...}}",               # «include helpers»
            "export {{...}}"                 # «export sqrt»

    # Spell each placeholder in a code pattern as `wordplaceholder`, because
    # Nim's grammar can't read a name that ends in an underscore, and
    # GenerateAST writes names in lower case.
    placeholder_suffix "placeholder"
  end
end
