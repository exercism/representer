# This file declares how the representer reads Elixir. REPRESENTER_DSL.md
# explains each declaration, and the other files in this folder hold
# Elixir's stages.
module Representer::Languages::Elixir
  class Spec < Representer::Engine::Language
    tracks "elixir"
    version 10
    grammar "elixir"
    extensions ".ex", ".exs"

    # The grammar calls each part of a module name an alias, such as `Shop` and
    # `Counter` in `Shop.Counter`.
    names_are :identifier,  # «count»
              :alias        # «Enum»

    # A module name defines each of its parts, so `defmodule Shop.Counter`
    # defines both `Shop` and `Counter`.
    names_are_defined_by :module_name # defmodule «Shop».«Counter» do ... end

    # A function head defines the function's name, and a type definition
    # defines the type's name.
    names_are_defined_by function_head: :target,  # def «area»(width, height) do ... end
                         type_definition: :left   # @type «count» :: integer

    # Every variable in a pattern, such as the left of `=`, is a definition.
    names_are_defined_by :variable # «total» = price * 2

    # Elixir's own attributes, such as `@impl`, are always set with a value.
    # An attribute that is read without a value, such as `@limit`, must be
    # one that the solution set itself, so reading it counts as a definition.
    names_are_defined_by :attribute # @«limit»

    # A solution that passes its tests has already made every module it
    # needs available, so the engine drops these imports. The engine keeps
    # `use`, because it runs code from the module.
    imports "alias {{module}}",   # «alias Shop.Counter»
            "import {{module}}",  # «import Enum»
            "require {{module}}"  # «require Logger»
  end
end
