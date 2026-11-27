# REPRESENTER_DSL.md defines every declaration in this file. Elixir's stages
# are the other files in this folder.
module Representer::Languages::Elixir
  class Spec < Representer::Engine::Language
    tracks "elixir"
    version 10
    grammar "elixir"
    extensions ".ex", ".exs"

    # Each part of a module's name is an alias.
    names_are :identifier,  # «count»
              :alias        # «Enum»

    # A module's name defines each of its parts.
    names_are_defined_by :module_name # defmodule «Shop».«Counter» do ... end

    # A function's head and a type definition define their names.
    names_are_defined_by function_head: :target,  # def «area»(width, height) do ... end
                         type_definition: :left   # @type «count» :: integer

    # A pattern defines each variable it binds.
    names_are_defined_by :variable # «total» = price * 2

    # Elixir's own attributes, such as `@impl`, are only ever set, so a
    # solution only reads its own attributes.
    names_are_defined_by :attribute # @«limit»

    # A solution that passes its tests has already made every module it
    # needs available, so the engine drops these imports. It keeps `use`,
    # which runs the module's code.
    imports "alias {{module}}",   # «alias Shop.Counter»
            "import {{module}}",  # «import Enum»
            "require {{module}}"  # «require Logger»
  end
end
