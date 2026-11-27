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
  end
end
