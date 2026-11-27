# This file declares how the representer reads Elixir. REPRESENTER_DSL.md
# explains each declaration, and the other files in this folder hold
# Elixir's stages.
module Representer::Languages::Elixir
  class Spec < Representer::Engine::Language
    tracks "elixir"
    version 10
    grammar "elixir"
    extensions ".ex", ".exs"

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
    imports "alias {{module}}",   # «alias Shop.Counter»
            "import {{module}}",  # «import Enum»
            "require {{module}}"  # «require Logger»
  end
end
