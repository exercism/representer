module Rosetta::Languages::Elixir::Representation
  class Spec < Rosetta::Engine::Representation
    version 10

    # Rename identifiers and aliases. The grammar calls each part of a module
    # name an alias, such as `Shop` and `Counter` in `Shop.Counter`.
    names_are :identifier,  # «count»
              :alias        # «Enum»

    # Rename each part of a module name, so `defmodule Shop.Counter` renames
    # both `Shop` and `Counter`.
    names_are_defined_by :module_name # defmodule «Shop».«Counter» do ... end

    # Rename the names of functions and types.
    names_are_defined_by function_head: :target,  # def «area»(width, height) do ... end
                         type_definition: :left   # @type «count» :: integer

    # Rename every variable in a pattern, such as the left of `=`.
    names_are_defined_by :variable # «total» = price * 2

    # Rename an attribute that is read without a value. Elixir's own attributes,
    # such as `@impl`, are always set with a value, so this one must be set by
    # the solution itself.
    names_are_defined_by :attribute # @«limit»

    # Drop these imports, because a solution that passes its tests has already
    # made every module it needs available. Keep `use`, because it runs code
    # from the module.
    imports "alias {{...}}",   # «alias Shop.Counter»
            "import {{...}}",  # «import Enum»
            "require {{...}}"  # «require Logger»
  end
end
