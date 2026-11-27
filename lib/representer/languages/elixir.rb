# Elixir's representer has three stages of its own, each in elixir/:
#
# - GenerateAST turns tree-sitter's tree into the tree given by Elixir's
#   own parser.
# - Normalise drops documentation, keeps two spellings of the old
#   representer (exercism/elixir-representer) the same, and moves each
#   `@spec` into its function.
# - Reorder sorts the code in each module's body and the entries of maps.
#
# The comment at the top of each file lists everything it does.
#
# This file declares Elixir's names and imports, and the engine does the
# rest:
#
# - A solution that passes its tests has already made available every
#   module it needs, so the engine drops every `alias`, `import` and
#   `require`. It keeps `use`, which runs the module's code.
# - The engine renames every name the solution defines, wherever the name
#   appears. A name counts as defined if it names a module, protocol,
#   function, macro, guard or type defined by the solution, a variable
#   bound by one of its patterns, or an attribute read by it. Each part of
#   a module's name is a name of its own.
# - A name not defined by the solution keeps its name, such as a call to
#   a library function, or a module of the standard library.
module Representer
  module Languages
    module Elixir
      extend StagedLanguage

      tracks "elixir"
      version 9
      grammar "elixir"
      extensions ".ex", ".exs"

      names_are :identifier,
                :alias

      names_are_defined_by :module_name,
                           :variable,
                           :attribute,
                           function_head: :target,
                           type_definition: :left

      imports "alias {{module}}",
              "import {{module}}",
              "require {{module}}"
    end
  end
end
