module Rosetta::Languages::Pyret::Representation
  class Spec < Rosetta::Engine::Representation
    version 6

    # Rename names, both where the solution defines them and where it uses
    # them.
    names_are :name,    # fun «leap»(year): ...
              :id_expr  # «year» + 1

    # Rename the names of functions, and of the values that a binding names:
    # parameters, `=`, `var` and `rec`, and the bindings in `for`, `cases` and
    # tuples.
    names_are_defined_by :fun_expr,      # fun «leap»(year): ...
                         :name_binding   # fun leap(«year»): ...

    # Rename the names of data types, their variants and type parameters, and
    # of type aliases.
    names_are_defined_by :data_expr,            # data «Shape»: ...
                         :variant_constructor,  # | «circle»(radius :: Number)
                         :data_variant,         # | «empty-shape»
                         :comma_names,          # fun first<«A»>(xs :: List<A>): ...
                         :type_expr,            # type «Point» = {x :: Number}
                         :newtype_expr,         # newtype «Box» as «BoxT»
                         :type_bind,            # type-let «Point» = Number: ...
                         :newtype_bind          # type-let newtype «Box» as «BoxT»: ...

    # Rename the keys of objects and of the methods of data types, and the
    # columns of tables.
    names_are_defined_by :key,           # { «count»: 0 }
                         :table_header   # table: «name», «age» ... end

    # Drop the context, the provides and the imports, because a solution that
    # passes its tests has already loaded everything it needs, and provides
    # everything that the tests use.
    imports "use context {{_}}",                  # «use context essentials2020»
            "provide: {{...}} end",               # «provide: leap end»
            "provide {{_}} end",                  # «provide { leap: leap } end»
            "provide *",                          # «provide *»
            "provide-types *",                    # «provide-types *»
            "include {{_}}",                      # «include string-dict»
            "include from {{...}}: {{...}} end",  # «include from L: map end»
            "import {{_}} as {{_}}",              # «import lists as L»
            "import {{...}} from {{_}}"           # «import map, filter from lists»
  end
end
