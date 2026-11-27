# REPRESENTER_DSL.md defines every declaration in this file. Elixir's stages
# are the other files in this folder.
module Representer::Languages::Elixir
  class Spec < Representer::Engine::Language
    tracks "elixir"
    version 10
    grammar "elixir"
    extensions ".ex", ".exs"

    # Identifiers hold the names of variables, functions and attributes, and
    # aliases hold the parts of module names, such as `Enum`.
    names_are :identifier,  # count
              :alias        # Counter

    # `defmodule` and `defprotocol` define their module's name. GenerateAST
    # splits a name such as `Foo.Bar` into its parts, so it defines both
    # `Foo` and `Bar`.
    names_are_defined_by :module_name # defmodule Counter do ... end

    # A `def`, `defp`, `defmacro`, `defmacrop`, `defguard`, `defguardp` or
    # `defdelegate` defines its function's name, and `@type t :: ...`
    # defines `t`.
    names_are_defined_by function_head: :target,  # def area(width, height) do ... end
                         type_definition: :left   # @type count :: integer

    # A pattern defines each variable it binds, such as `x` in `x = 1` or in
    # `def f(x)`.
    names_are_defined_by :variable # total = 0

    # Elixir's own attributes, such as `@impl`, are only ever set, so a
    # solution only reads its own attributes. Reading `@limit` defines
    # `limit`.
    names_are_defined_by :attribute # @limit

    # A solution that passes its tests has already made available every
    # module it needs, so the engine drops every `alias`, `import` and
    # `require`. It keeps `use`, which runs the module's code.
    imports "alias {{module}}",   # alias MyApp.Counter
            "import {{module}}",  # import Enum
            "require {{module}}"  # require Logger
  end
end
